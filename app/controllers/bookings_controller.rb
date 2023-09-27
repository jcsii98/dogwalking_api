class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_booking, only: [:update, :destroy, :show]

    def index
        if current_user.kind == "2"
            @bookings = current_user.bookings
            render json: @bookings
        else
            dog_walking_job = current_user.dog_walking_jobs.find_by(id: params[:dog_walking_job_id])
            
            if dog_walking_job
                @bookings = dog_walking_job.bookings
                render json: @bookings
            else
                # Handle the case where the user doesn't have a dog_walking_job
                render json: { error: "You are not associated with any dog_walking_job." }, status: :unprocessable_entity
            end
        end
    end


    def create
        @booking = current_user.bookings.create(booking_params)
        
        if @booking.save
            render json: @booking, status: :created
        else
            render json: @booking.errors, status: :unprocessable_entity
        end
    end

    def show
        @booking_dog_profiles = @booking.booking_dog_profiles
        
        render json: {
            booking: @booking,
            booking_dog_profiles: @booking_dog_profiles.map { |bdp| { id: bdp.id, dog_profile: bdp.dog_profile } }
        }
    end


    def update
        if current_user.kind == "2"
            if @booking.status == 'approved'
                render json: { status: 'error', message: 'cannot edit an approved booking' }, status: :forbidden
                return
            else
                if @booking.update(booking_params)
                    render json: { status: 'success', data: @booking }
                else
                    render json: { status: 'error', errors: @booking.errors.full_messages }, status: :unprocessable_entity
                end
            end
        else
            if @booking.update(status: 'approved')
                render json: { status: 'success', message: 'booking approved' }, status: :ok
            else
                render json: { status: 'error', errors: @booking.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end

    def destroy
        if current_user.kind == "2"
            if @booking.update(archived: true)
                render json: { status: 'success', message: 'Booking has been archived' }
            else
                render json: { status: 'error', errors: @booking.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { message: 'Cannot delete booking' }, status: :forbidden
        end
    end

    private
    
    def set_booking
        @booking = Booking.find(params[:id])
    end

    def booking_params
        params.require(:booking).permit(
        :dog_walking_job_id,
        :date,
        :amount,
        :status,
        :duration,
        :archived,
        booking_dog_profiles_attributes: [:id, :dog_profile_id, :_destroy]
        )
    end

end
