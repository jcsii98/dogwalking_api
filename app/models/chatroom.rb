class Chatroom < ApplicationRecord
  belongs_to :booking

  before_create :set_owner_and_walker_users

  private
  
  def set_owner_and_walker_users
    self.owner_user_id = booking.user_id
    self.walker_user_id = booking.dog_walking_job.user_id
  end

end
