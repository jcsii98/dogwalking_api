class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    chatroom = Chatroom.find(params[:id])
    
    user = Rails.env.test? ? User.find(connection.current_user_id) : current_user

    if chatroom.user_associated?(user)
      stream_for chatroom

      add_online_user(chatroom, user.id)

      self.class.broadcast_to(chatroom, type: 'users_online', users: online_users(chatroom).to_a)
    else
      reject
    end
  end

  def unsubscribed
    chatroom = Chatroom.find(params[:id])

    remove_online_user(chatroom, current_user.id)

    self.class.broadcast_to(chatroom, type: 'users_online', users: online_users(chatroom).to_a)
  end

  private
  
  def online_users(chatroom)
    cache_key = "chatroom_#{chatroom.id}_online_users"
    Rails.cache.read(cache_key) || Set.new
  end

  def add_online_user(chatroom, user_id)
    cache_key = "chatroom_#{chatroom.id}_online_users"
    users = online_users(chatroom)
    users.add(user_id)
    Rails.cache.write(cache_key, users)
  end

  def remove_online_user(chatroom, user_id)
    cache_key = "chatroom_#{chatroom.id}_online_users"
    users = online_users(chatroom)
    users.delete(user_id)
    Rails.cache.write(cache_key, users)
  end
end
