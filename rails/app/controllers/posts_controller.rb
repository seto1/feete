class PostsController < ApplicationController
  skip_forgery_protection

  before_action :before_action
  after_action :after_action

  def before_action
    begin
      jwt_decode = JWT.decode(params[:token], Rails.application.secrets.secret_key_base)
      @jwt_data = jwt_decode.first

      db_path = Rails.configuration.database_configuration[ENV['RAILS_ENV']]['database']
      decrypt = EncryptFileService.decrypt(
        source: File.expand_path('db/enc'),
        dest: File.expand_path(db_path),
        key: jwt_decode.first['key']
      )
      raise 'db decrypt error' unless decrypt
    rescue => e
      return render json: { error: e }
    end
  end

  def after_action
    db_path = Rails.configuration.database_configuration[ENV['RAILS_ENV']]['database']
    EncryptFileService.encrypt(
      key: @jwt_data['key'],
      source: File.expand_path(db_path),
      dest: File.expand_path('db/enc')
    )
    EncryptFileService.delete(File.expand_path(db_path))
  end

  def index
    render json: {}
  end

  def create
    render json: {}
  end

  def update
    render json: {}
  end
end
