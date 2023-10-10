class DogWalkingJobsController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_kind, except: [:show, :index, :destroy]
    
    before_action :set_dog_walking_job, only: [:update, :destroy]
    
    def index
        if current_user.kind == "1"
            @dog_walking_job = current_user.dog_walking_job
            if @dog_walking_job
                render json: { data: @dog_walking_job }
            else
                render json: { message: "No dog-walking job found for this user" }
            end
        else
            specified_user = User.find_by(id: params[:user_id])
            if specified_user
                @dog_walking_jobs = specified_user.dog_walking_jobs.where(archived: false)
                if @dog_walking_jobs.empty?
                    render json: { message: "No dog-walking jobs found for this user" }
                else
                    render json: { data: @dog_walking_jobs }
                end
            else
                render json: { message: "Specified user not found" }, status: :not_found
            end
        end
    end

    def create
        @dog_walking_job = current_user.create_dog_walking_job(dog_walking_job_params)
        if @dog_walking_job.save
            render json: @dog_walking_job, status: :created
        else
            render json: @dog_walking_job.errors, status: :unprocessable_entity
        end
    end

    def show
        dog_walking_job = DogWalkingJob.find(params[:id])
        
        render json: { status: 'success', data: dog_walking_job }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'error', message: "Dog-walking job not found" }
    end

    def update
        if @dog_walking_job.update(dog_walking_job_params)
            render json: { status: 'success', data: @dog_walking_job }
        else
            render json: { status: 'error', errors: @dog_walking_job.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        if current_user.kind == "1"
            if @dog_walking_job.destroy
                render json: { status: 'success', message: 'Dog-walking job has been deleted' }
            else
                render json: { status: 'error', errors: @dog_walking_job.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { message: 'Access denied. Kind must be 1'}, status: :forbidden
        end
    end

    private

    def verify_kind
        unless current_user.kind == "1"
            render json: { message: "Access denied. Kind must be '1'"}, status: :forbidden
        end
    end

    def dog_walking_job_params
        params.require(:dog_walking_job).permit(:name, :wgr1, :wgr2, :wgr3, :hidden, :archived)
    end

    def set_dog_walking_job
        @dog_walking_job = current_user.dog_walking_jobs.find(params[:id])
    end

end