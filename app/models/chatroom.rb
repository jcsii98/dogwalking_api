class Chatroom < ApplicationRecord
  belongs_to :booking
  has_many :messages, dependent: :destroy

  def user_associated?(user)
    booking.user_owner_id == user.id || booking.user_walker_id == user.id
  end

  private
  
end
