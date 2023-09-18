class DogProfilesController < ApplicationController
    before_action :verify_kind

    def index
        render json: { message: "Hi"}
    end

    def create
        
    end

    def show

    end

    def update

    end

    def destroy

    end

    private

    def verify_kind
        unless current_user.kind == "2"
            render json: { message: "Access denied. Kind must be '2'"}, status: :forbidden
        end
    end
end