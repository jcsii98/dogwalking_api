class Booking < ApplicationRecord
  belongs_to :dog_walking_job
  belongs_to :user
  
  has_many :booking_dog_profiles, dependent: :destroy
  has_many :dog_profiles, through: :booking_dog_profiles
  has_one :chatroom, dependent: :destroy

  after_create :create_chatroom

  accepts_nested_attributes_for :booking_dog_profiles

  private

  def create_chatroom
    build_chatroom.save
  end
  
end
