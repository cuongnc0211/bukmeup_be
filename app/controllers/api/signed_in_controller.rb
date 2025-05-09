class Api::SignedInController < Api::BaseController
  before_action :authenticate_devise_api_token!
  # before_action :authenticate_api!
  helper_method :current_user

  private

  # # Main authentication method that handles token validation
  # def authenticate_user_from_token!
  #   token = extract_token_from_authorization_header

  #   @current_user = User.find_by(auth_token: token)
  #   raise UnauthorizedError, "Invalid or expired token" if @current_user.nil?
  # end

  # # Extract token from Authorization header
  # def extract_token_from_authorization_header
  #   authorization_header = request.headers["Authorization"]
  #   raise UnauthorizedError, "Missing or malformed Authorization header" if authorization_header.blank?

  #   prefix, token = authorization_header.split(" ")
  #   raise UnauthorizedError, "Invalid token format" unless prefix == 'Bearer'

  #   token
  # end

  # Current user accessible throughout the controller
  def current_user
    current_devise_api_token.resource_owner
  end
end
