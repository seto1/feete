class PostsController < ActionController::API
  before_action :before_action
  after_action :after_action

  def before_action
    # key = header_key
    # begin
    #   jwt_decode = JWT.decode(key, Rails.application.secrets.secret_key_base)
    #   @jwt_data = jwt_decode.first
    #
    #   raise 'key error' unless jwt_decode.first['key']
    #
    #   db_path = Rails.configuration.database_configuration[ENV['RAILS_ENV']]['database']
    #   decrypt = EncryptFileService.decrypt(
    #     source: File.expand_path('db/enc'),
    #     dest: File.expand_path(db_path),
    #     key: jwt_decode.first['key']
    #   )
    #   raise 'db decrypt error' unless decrypt
    # rescue => e
    #   return render json: { error: e }
    # end
  end

  def header_key
    authorization = request.headers[:Authorization]
    return false unless authorization
    match = authorization.match(/\ABearer\s+(.+)/)
    match[1] if match
  end

  def after_action
    # db_path = Rails.configuration.database_configuration[ENV['RAILS_ENV']]['database']
    # EncryptFileService.encrypt(
    #   key: @jwt_data['key'],
    #   source: File.expand_path(db_path),
    #   dest: File.expand_path('db/enc')
    # )
    # EncryptFileService.delete(File.expand_path(db_path))
  end

  def index
    posts = Post.all.order(id: 'DESC')
    render json: { success: true, posts: posts }
  end

  def create
    json_request = JSON.parse(request.body.read)

    now = Time.current
    puts now.strftime('%Y-%m-%d %H:%M:%S')
    post = Post.new(text: json_request['text'], date: now.strftime('%Y-%m-%d %H:%M:%S'))

    if post.save
      render json: { success: true }
    else
      render json: { error: 'failed to create', validate: post.errors.messages }
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
    json_request = JSON.parse(request.body.read)

    begin
      post = Post.find(json_request['id'])
    rescue => e
      return render json: { error: e }
    end

    if post.destroy
      render json: { success: true }
    else
      render json: { error: 'failed to delete' }
    end
  end
end
