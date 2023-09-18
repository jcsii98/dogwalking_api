class DogWalkingJobsController < ApplicationController
    before_action :authenticate_user!
    before_action :verify_kind
    def index
        @dog_walking_jobs = current_user.dog_walking_jobs.where(archived: false)
        if @dog_walking_jobs.empty?
            render json: { message: "No dog walking jobs found for this user" }
        else
            render json: { data: @dog_walking_jobs}
        end

    end

    def create
        @dog_walking_job = current_user.dog_walking_jobs.new(dog_walking_job_params)
        if @dog_walking_job.save
            render json: @dog_walking_job, status: :created
        else
            render json: @dog_walking_job.errors, status: :unprocessable_entity
        end
    end

    private

    def verify_kind
        unless current_user.kind == "2"
            render json: { message: "Access denied. Kind must be '1'"}, status: :forbidden
        end
    end

    def dog_walking_job_params
        params.require(:dog_walking_job).permit(:name, :wgr1, :wgr2, :wgr3, :hidden, :archived)
    end
end