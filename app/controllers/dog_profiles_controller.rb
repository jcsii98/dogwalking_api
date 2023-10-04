class DogProfilesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_dog_profile, only: [:update, :destroy, :show]
    before_action :verify_kind, only: [:index, :create, :update, :destroy] # kind = 2
    
    def index
        @dog_profiles = current_user.dog_profiles.where(archived: false)
        
        if @dog_profiles.empty?
            render json: { message: "No dog profiles found for this user" }
        else
            render json: { data: @dog_profiles }
        end
    end

    def create
        dog_profile = current_user.dog_profiles.new(dog_profile_params)

        if dog_profile.save
            render json: dog_profile, status: :created
        else
            render json: { errors: dog_profile.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        if @dog_profile
            render json: { status: 'success', data: @dog_profile }, status: :ok
        else
            render json: {status: 'error', message: 'Dog profile not found' }, status: :not_found
        end
    end

    def update
        if @dog_profile.update(dog_profile_params)
            render json: { status: 'success', data: @dog_profile }
        else
            render json: { status: 'error', errors: @dog_profile.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        if @dog_profile.destroy
            render json: { status: 'success', message: 'Dog Profile has been deleted' }
        else
            render json: { status: 'error', errors: @dog_profile.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def verify_kind
        unless current_user.kind == "2"
            render json: { message: "Access denied. Kind must be '2'"}, status: :forbidden
        end
    end

    def dog_profile_params
        params.require(:dog_profile).permit(:name, :breed, :age, :sex, :weight, :hidden, :archived)
    end

    def set_dog_profile
        @dog_profile = current_user.dog_profiles.find_by(id: params[:id])
    end

end

