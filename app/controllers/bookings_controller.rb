class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_booking, only: [:update, :destroy, :show]

    def index
        @bookings = current_user.bookings
        render json: @bookings
    end

    def create
        @booking = current_user.bookings.build(booking_params)
        if @booking.save
            render json: @booking, status: :created
        else
            render json: @booking.errors, status: :unprocessable_entity
        end
    end

    def show
        
        @dog_profiles = @booking.dog_profiles
        render json: @dog_profiles
    end

    def update
        
        if @booking.update(booking_params)
            render json: { status: 'success', data: @booking }
        else
            render json: { status: 'error', errors: @booking.errors.full_messages }, status: :unprocessable_entity
        end

    end

    def destroy
        if @booking.update(archived: true)
            render json: { status: 'success', message: 'Booking has been archived' }
        else
            render json: { status: 'error', errors: @booking.errors.full_messages }, status: :unprocessable_entity
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
        booking_dog_profiles_attributes: [:dog_profile_id]
        )
    end

end
