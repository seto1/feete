class PostsController < ActionController::API
  before_action :before_action
  after_action :after_action

  def before_action
    begin
      key = header_key
      decrypt = EncryptFileService.decrypt(
        source: File.expand_path('db/enc'),
        dest: File.expand_path(Rails.configuration.app['dbPath']),
        key: key
      )
      raise 'db decrypt error' unless decrypt
    rescue => e
      return render json: { error: e }
    end
    @db = SQLite3::Database.new Rails.configuration.app['dbPath']
    @db.results_as_hash = true
  end

  def header_key
    authorization = request.headers[:Authorization]
    return false unless authorization
    match = authorization.match(/\ABearer\s+(.+)/)
    return unless match

    secret = Rails.application.secrets.secret_key_base
    secret = Digest::SHA256.hexdigest(secret)
    secret = secret.slice(0, 32)
    encryptor = ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
    encryptor.decrypt_and_verify(match[1])
  end

  def after_action
    key = header_key
    EncryptFileService.encrypt(
      key: key,
      source: File.expand_path(Rails.configuration.app['dbPath']),
      dest: File.expand_path('db/enc')
    )
    EncryptFileService.delete(File.expand_path(Rails.configuration.app['dbPath']))
  end

  def index
    sql = <<-SQL
      SELECT * FROM POSTS ORDER BY id DESC;
    SQL
    posts = []
    @db.execute(sql) do |row|
      posts.push(row)
    end
    render json: { success: true, posts: posts }
  end

  def create
    json_request = JSON.parse(request.body.read)

    # todo validate

    begin
      now = Time.current
      sql = <<-SQL
        INSERT INTO posts (text, date) VALUES (?, ?);
      SQL
      @db.prepare(sql).execute(json_request['text'], now.strftime('%Y-%m-%d %H:%M:%S'))
      render json: { success: true }
    rescue => e
      render json: { error: 'failed to create' }
    end
  end

  def update
    json_request = JSON.parse(request.body.read)

    begin
      post = Post.find(json_request['id'])
    rescue => e
      return render json: { error: e }
    end

    if post.update(text: json_request['text'])
      render json: { success: true }
    else
      render json: { error: 'failed to update', validate: post.errors.messages }
    end
  end

  def destroy
    begin
      sql = <<-SQL
        SELECT * FROM posts WHERE id = ?
      SQL
      posts = @db.prepare(sql).execute(params[:id])
      post = posts.first
      raise 'post doesnt exist' unless post

      sql = <<-SQL
        DELETE FROM posts WHERE id = ?
      SQL
      @db.prepare(sql).execute(params[:id])

      sql = <<-SQL
        SELECT * FROM posts WHERE id = ?
      SQL
      posts = @db.prepare(sql).execute(params[:id])
      post = posts.first
      raise 'failed to delete' if post && post.size

      render json: { success: true }
    rescue => e
      return render json: { error: e }
    end
  end
end
