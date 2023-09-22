class ChatroomsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_booking, only: [:update, :destroy, :show]

    # GET /bookings/:booking_id/chatroom
    
    def show
        @chatroom = @booking.chatroom
        render json: @chatroom
    end

    private
    
    def set_booking
        @booking = Booking.find(params[:booking_id])
    end



end
