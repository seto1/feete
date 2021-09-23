class TokenController < ApplicationController
  skip_forgery_protection

  def jwt
    # TODO: 期間設定
    preload = { test: 'test', exp: 1.month.from_now.to_i }
    token = JWT.encode(preload, Rails.application.secrets.secret_key_base)
    render json: { jwt: token }
  end

  def decode
    begin
      decode = JWT.decode(params[:token], Rails.application.secrets.secret_key_base)
      render json: decode.first
    rescue => e
      render json: { error: e.message }
    end
  end

end
