class ChatroomChannel < ApplicationCable::Channel::Base
  def subscribed
    chatroom = Chatroom.find(params[:id])
    
    # Check if it's a test environment, and set the user accordingly
    user = Rails.env.test? ? User.find(connection.current_user_id) : current_user
    
    if chatroom.user_associated?(user)
      stream_for chatroom

      self.class.broadcast_to(chatroom, type: 'user_connected', user: user.name)
    else
      reject
    end
  end

  def unsubscribed
    chatroom = Chatroom.find(params[:id])

    self.class.broadcast_to(chatroom, type: 'user_disconnected', user: current_user.name)
  end
end
