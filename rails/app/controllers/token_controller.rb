class TokenController < ApplicationController
  skip_forgery_protection

  def jwt
    begin
      raise 'key error' unless EncryptFileService.check_key(
        path: File.expand_path('db/enc'),
        key: params[:key]
      )
      exp = ENV['TOKEN_EXPIRE'].to_i.public_send(ENV['TOKEN_EXPIRE_UNIT']).from_now.to_i
      preload = { key: params[:key], exp: exp }
      token = JWT.encode(preload, Rails.application.secrets.secret_key_base)
      render json: { jwt: token }
    rescue => e
      render json: { error: e }
    end
  end

  def decode
    begin
      jwt_decode = JWT.decode(params[:token], Rails.application.secrets.secret_key_base)
      render json: jwt_decode.first
    rescue => e
      render json: { error: e.message }
    end
  end

end
