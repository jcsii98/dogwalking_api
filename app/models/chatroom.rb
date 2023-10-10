class Chatroom < ApplicationRecord
  belongs_to :booking
  has_many :messages, dependent: :destroy
  before_create :set_owner_and_walker_users

  def user_associated?(user)
    booking.user_owner_id == user.id || booking.user_walker_id == user.id
  end

  private
  
end
