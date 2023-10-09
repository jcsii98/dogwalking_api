class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find(params[:id])
    
    # Check if it's a test environment, and set the user accordingly
    user = Rails.env.test? ? User.find(connection.current_user_id) : current_user
    
    if chatroom.user_associated?(user)
      stream_for chatroom
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
