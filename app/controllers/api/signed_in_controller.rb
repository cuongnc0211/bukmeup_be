class Api::SignedInController < Api::BaseController
  before_action :authenticate_user_from_token!

  private

  # Main authentication method that handles token validation
  def authenticate_user_from_token!
    token = extract_token_from_authorization_header

    @current_user = User.find_by(auth_token: token)
    raise UnauthorizedError, "Invalid or expired token" if @current_user.nil?
  end

  # Extract token from Authorization header
  def extract_token_from_authorization_header
    authorization_header = request.headers["Authorization"]
    raise UnauthorizedError, "Missing or malformed Authorization header" if authorization_header.blank?

    prefix, token = authorization_header.split(" ")
    raise UnauthorizedError, "Invalid token format" unless prefix == 'Bearer'

    token
  end

  # Decode the JWT token
  def decode_jwt(token)
    hmac_secret = Rails.application.credentials.config[:hmac_secret]
    decoded_token = JWT.decode(token, hmac_secret, true, { algorithm: 'HS256' }).first

    raise UnauthorizedError, "Invalid token" if decoded_token.blank? || decoded_token['id'].blank?

    decoded_token
  rescue JWT::DecodeError
    raise UnauthorizedError, "Invalid or expired token"
  end

  # Current user accessible throughout the controller
  def current_user
    @current_user
  end
end
