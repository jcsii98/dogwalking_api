class ChatroomsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_booking
    before_action :check_user_association

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
        ChatroomChannel.broadcast_to(@booking.chatroom, @message.as_json(include: { user: { only: [:id, :name] } }))
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

    def check_user_association
        unless @booking.chatroom.user_associated?(current_user)
            render json: { error: "You're not permitted to view or interact with this chatroom" }, status: :forbidden
        end
    end

end
