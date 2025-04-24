module Api
  class V1::UsersController < SignedInController
    def profile
      render json: UserBlueprint.render(current_devise_api_user)
    end
  end
end
