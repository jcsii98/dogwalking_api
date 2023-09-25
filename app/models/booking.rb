class Booking < ApplicationRecord
  belongs_to :dog_walking_job
  belongs_to :user
  
  has_many :booking_dog_profiles, dependent: :destroy
  has_many :dog_profiles, through: :booking_dog_profiles
  has_one :chatroom, dependent: :destroy

  after_create :create_chatroom
  before_save :calculate_billing_amount

  accepts_nested_attributes_for :booking_dog_profiles

  private

  def create_chatroom
    build_chatroom.save
  end

  def calculate_billing_amount
    if dog_profiles.any?
      total_amount = 0
      dog_profiles.each do |dog_profile|
        weight = dog_profile.weight
        job = dog_walking_job

        if weight < 20
          rate = job.wgr1
        elsif weight < 60
          rate = job.wgr2
        else
          rate = job.wgr3
        end

        total_amount += self.duration * rate
      end

      self.amount = total_amount
    end
  end

  
end
