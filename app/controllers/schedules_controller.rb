class SchedulesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_dog_walking_job
    before_action :verify_job_owner, only: [:create, :update, :destroy]

    def index
        if current_user.kind == "2"
            @schedules = @dog_walking_job.schedules.where(hidden: false)
            render json: { data: @schedules }
        else
            @schedules = @dog_walking_job.schedules
            render json: { data: @schedules }
        end
    end

    def create
        @schedule = @dog_walking_job.schedules.new(schedule_params)
        if @schedule.save
            render json: { status: 'success', message: 'schedule has been saved' }
        else
            render json: { status: 'error', errors: @schedule.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        @schedule = @dog_walking_job.schedules.find(params[:id])
        
        if @schedule
            render json: { status: 'success', data: @schedule }, status: :ok
        else
            render json: { status: 'error', message: 'schedule not found' }
        end
    end

    def update
        @schedule = @dog_walking_job.schedules.find(params[:id])

        if @schedule.update(schedule_params)
            render json: { status: 'success', data: @schedule }
        else
            render json: { status: 'error', errors: @schedule.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @schedule = @dog_walking_job.schedules.find(params[:id])
        if @schedule.destroy
            render json: { status: 'success', message: 'schedule deleted' }
        else
            render json: { status: 'error', errors: @schedule.errors.full_messages }
        end
    end

    private
    
    def set_dog_walking_job
        @dog_walking_job = DogWalkingJob.find(params[:dog_walking_job_id])
    end

    def verify_job_owner
        unless current_user == @dog_walking_job.user
        render json: { status: 'error', message: 'You do not have permission to perform this action.' },
                status: :unauthorized
        end
    end

    def schedule_params
        params.require(:schedule).permit(:day, :start_time, :end_time, :hidden)
    end

end
