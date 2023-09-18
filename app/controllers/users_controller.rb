class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
        user = current_user
        render json: current_user
    end

    def update
        user = current_user
        if user.kind.present?
            render json: { message: "kind has already been set" }
        else
            if user.update(user_params)
                render json: user
            else
                render json: { errors: user.errors }, status: :unprocessable_entity
            end
        end
    end

    private

    def user_params
        params.require(:user).permit(:kind)
    end
end