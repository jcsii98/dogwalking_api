class ChatroomsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_booking

    # GET /bookings/:booking_id/chatroom
    def show
        @chatroom = @booking.chatroom
        @messages = @chatroom.messages
        render json: {
            chatroom: @chatroom,
            messages: @messages
        }
    end

    # POST /bookings/:booking_id/chatroom/messages
    def create_message
        @message = @booking.chatroom.messages.new(message_params)
        @message.user = current_user

        if @message.save
        render json: @message, status: :created
        else
        render json: @message.errors, status: :unprocessable_entity
        end
    end

    private
    
    def set_booking
        @booking = Booking.find(params[:booking_id])
    end

    def message_params
        params.require(:message).permit(:content)
    end

end
