class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
        user = current_user
        render json: current_user
    end

    def update
        user = current_user
        if user.update(user_params)
            render json: user
        else
            render json: { errors: user.errors }, status: :unprocessable_entity
        end
    end

    private

    def user_params
        params.require(:user).permit(:kind, :name, :street_address, :city, :state, :country)
    end
end