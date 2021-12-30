class PostsController < ActionController::API
  before_action :before_action
  after_action :after_action

  def before_action
    begin
      key = header_key
      decrypt = EncryptFileService.decrypt(
        source: File.expand_path(Rails.configuration.app['dbEncPath']),
        dest: File.expand_path(Rails.configuration.app['dbPath']),
        key: key
      )
      raise 'db decrypt error' unless decrypt
    rescue => e
      return render json: { error: e }
    end
    ActiveRecord::Base.establish_connection(
      adapter:   'sqlite3',
      database:  Rails.configuration.app['dbPath']
    )
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
      dest: File.expand_path(Rails.configuration.app['dbEncPath'])
    )
    EncryptFileService.delete(File.expand_path(Rails.configuration.app['dbPath']))
  end

  def index
    posts = Post.all.order(id: 'DESC')
    render json: { success: true, posts: posts }
  end

  def create
    json_request = JSON.parse(request.body.read)

    # todo validate

    now = Time.current
    post = Post.new(text: json_request['text'], date:now.strftime('%Y-%m-%d %H:%M:%S'))

    if post.save
      render json: { success: true }
    else
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
      post = Post.find(params[:id])
    rescue => e
      return render json: { error: e }
    end

    if post.destroy
      render json: { success: true }
    else
      return render json: { error: 'failed to delete' }
    end
  end
end
