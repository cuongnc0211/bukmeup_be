module Api
  class V1::AuthenticationController < BaseController
    def login
      user = User.find_by(email: params[:email])

      if user && user.valid_password?(params[:password])
        token = user.generate_token
        user.update_column(:auth_token, token)

        render json: {auth_token: token}, status: :ok
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end
  end
end
