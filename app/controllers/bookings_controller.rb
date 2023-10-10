class BookingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_booking, only: [:update, :destroy, :show]

    def index
        if current_user.kind == "2"
            @bookings = current_user.owner_bookings
            if @bookings.empty?
                render json: { error: "No bookings found" }, status: :not_found
            else
                render json: @bookings.as_json(include: { dog_profiles: { only: [:id, :name, :weight, :breed, :age, :sex] } })
            end
        else
            @bookings = current_user.walker_bookings
            if @bookings.empty?
                render json: { error: "No bookings found" }, status: :not_found
            else
                # Handle the case where the user doesn't have a dog_walking_job
                render json: @bookings.as_json(include: { dog_profiles: { only: [:id, :name, :weight, :breed, :age, :sex] } })
            end
        end
    end


    def create
        if current_user.kind == '2'
            @booking = current_user.owner_bookings.build(booking_params)

            @walker = User.find_by(id: booking_params[:user_walker_id])
            if @walker.nil?
                render json: { error: "Walker not found" }, status: :not_found
                return
            end

            @booking.user_walker = @walker

            if @booking.save
                render json: @booking, status: :created
            else
                render json: @booking.errors, status: :unprocessable_entity
            end
        else
            render json: { error: "You are not authorized" }, status: :forbidden
        end
    rescue ActiveRecord::RecordNotUnique
        render json: { error: "A dog can't be added to the same booking twice" }
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
            elsif @booking.update(booking_params)
                @booking.save
                broadcast_booking_updated
            else
                render json: { status: 'error', errors: @booking.errors.full_messages }, status: :unprocessable_entity
            end
        else
            if @booking.update(status: 'approved')
                broadcast_booking_updated
                render json: { status: 'success', message: 'booking approved' }, status: :ok
            else
                render json: { status: 'error', errors: @booking.errors.full_messages }, status: :unprocessable_entity
            end
        end
        rescue ActiveRecord::RecordNotUnique
        render json: { error: "A dog can't be added to the same booking twice" }
    end

    def destroy
        if @booking.destroy
            ChatroomChannel.broadcast_to(@booking.chatroom, { type: 'booking_deleted', booking_id: @booking.id })
            render json: { status: 'success', message: 'Booking has been deleted' }
        else
            render json: { status: 'error', errors: @booking.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private

    def broadcast_booking_updated
        ChatroomChannel.broadcast_to(@booking.chatroom, { type: 'booking_updated', booking: @booking })
        render json: { status: 'success', data: @booking }
    end

    def set_booking
        @booking = Booking.find(params[:id])
    end

    def booking_params
        params.require(:booking).permit(
        :date,
        :amount,
        :status,
        :duration,
        :user_walker_id,
        booking_dog_profiles_attributes: [:id, :dog_profile_id, :_destroy]
        )
    end

end
