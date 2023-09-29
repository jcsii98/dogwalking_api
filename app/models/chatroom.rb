class Chatroom < ApplicationRecord
  belongs_to :booking
  has_many :messages, dependent: :destroy
  before_create :set_owner_and_walker_users

  def user_associated?(user)
    owner_user_id == user.id || walker_user_id == user.id
  end

  private
  
  def set_owner_and_walker_users
    self.owner_user_id = booking.user_id
    self.walker_user_id = booking.dog_walking_job.user_id
  end



end
