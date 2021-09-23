class InitController < ApplicationController
  skip_forgery_protection

  def index
    db_path = Rails.configuration.database_configuration[ENV['RAILS_ENV']]['database']
    db_path = File.expand_path(db_path)
    unless (File.exist?(db_path))
      return render json: { error: 'db doesnt exist' }
    end

    begin
      EncryptFileService.encrypt(
        key: params[:key],
        source: db_path,
        dest: File.expand_path('db/enc')
      )
      EncryptFileService.delete(db_path)
      render json: { success: true }
    rescue => e
      render json: { error: e.message }
    end
  end
end
