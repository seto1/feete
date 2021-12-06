class TokenController < ApplicationController
  skip_forgery_protection

  def create
    begin
      json_request = JSON.parse(request.body.read)
      raise 'key error' unless EncryptFileService.check_key(
        path: File.expand_path('db/enc'),
        key: json_request['key']
      )
      secret = Rails.application.secrets.secret_key_base
      secret = Digest::SHA256.hexdigest(secret)
      secret = secret.slice(0, 32)
      encryptor = ActiveSupport::MessageEncryptor.new(secret, cipher: 'aes-256-cbc')
      token = encryptor.encrypt_and_sign(json_request['key'])
      render json: { token: token }
    rescue => e
      render json: { error: e }
    end
  end

  def test
    render json: { test: 'success' }
  end

end
