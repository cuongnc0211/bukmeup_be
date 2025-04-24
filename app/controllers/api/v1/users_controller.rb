module Api
  class V1::UsersController < SignedInController
    def logout
      if current_user
        current_user.update_column(:auth_token, nil)
        render json: {msg: "Auth token revoked!"}, status: :ok
      else
        render json: { error: 'Invalid auth token' }, status: :unauthorized
      end
    end
  end
end
