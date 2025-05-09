module Api
  class V1::UsersController < SignedInController
    def profile
      render json: UserBlueprint.render(current_devise_api_user)
    end

    def update
      current_user.update!(user_attributes)

      render json: UserBlueprint.render(current_user.reload)
    end

    def confirm_email
      @user = User.find_by(confirmation_token: params[:confirmation_token])

      if @user && @user.confirmation_sent_at <= Time.zone.now + 15.minutes
        render json: { msg: "active successfully" }, status: :ok
      else
        render json: { error: "Active code is invalid or expired" }, status: :bad_request
      end
    end

    private

    def user_attributes
      params.permit(%i[first_name last_name phone_number avatar cover])
    end
  end
end
