class Api::SignedInController < Api::BaseController
  before_action :authenticate_access_token
  before_action :authenticate_user_from_token!

  private

  def authenticate_access_token
    true
  end

  def authenticate_user_from_token!
    prefix, token = request.headers["Authorization"]&.split(" ")
    return if token.blank? || prefix != 'Bearer'

    user_id = decode_jwt(token)
    @current_user = User.find_by(id: user_id)
  end

  def decode_jwt(token)
    JWT.decode(token, Rails.application.secret_key_base)[0]["sub"]
  rescue
    nil
  end

  def current_user
    @current_user
  end
end
