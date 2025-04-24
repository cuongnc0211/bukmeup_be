module Api
  class V1::UsersController < SignedInController
    def show
      user = User.find(params[:id])

      render json: puts UserBlueprint.render(user)
    end
  end
end
