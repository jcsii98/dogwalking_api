class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find(params[:id])
    
    user = Rails.env.test? ? User.find(connection.current_user_id) : current_user

    if chatroom.user_associated?(user)
      stream_for chatroom

      online_users(chatroom).add(user.id)

      self.class.broadcast_to(chatroom, type: 'users_online', users: online_users(chatroom).to_a)
    else
      reject
    end
  end

  def unsubscribed
    chatroom = Chatroom.find(params[:id])

    online_users(chatroom).delete(current_user.id)

    self.class.broadcast_to(chatroom, type: 'users_online', users: online_users(chatroom).to_a)
  end

  private
  
  def online_users(chatroom)
    Rails.cache.fetch("chatroom_#{chatroom.id}_online_users") { Set.new }
  end
end
