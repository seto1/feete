class TokenController < ApplicationController
  skip_forgery_protection

  def jwt
    begin
      json_request = JSON.parse(request.body.read)
      raise 'key error' unless EncryptFileService.check_key(
        path: File.expand_path('db/enc'),
        key: json_request['key']
      )
      exp = ENV['TOKEN_EXPIRE'].to_i.public_send(ENV['TOKEN_EXPIRE_UNIT']).from_now.to_i
      preload = { key: json_request['key'], exp: exp }
      token = JWT.encode(preload, Rails.application.secrets.secret_key_base)
      render json: { jwt: token }
    rescue => e
      render json: { error: e }
    end
  end

  def test
    render json: { test: 'success' }
  end

end
