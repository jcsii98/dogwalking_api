class Booking < ApplicationRecord
  belongs_to :dog_walking_job
  belongs_to :user

  belongs_to :user_owner, class_name: 'User', foreign_key: 'user_owner_id'
  belongs_to :user_walker, class_name: 'User', foreign_key: 'user_walker_id'

  has_many :booking_dog_profiles, dependent: :destroy
  has_many :dog_profiles, through: :booking_dog_profiles
  has_one :chatroom, dependent: :destroy

  after_create :create_chatroom

  accepts_nested_attributes_for :booking_dog_profiles, allow_destroy: true

  
  before_save :calculate_billing_amount

  validates :duration, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true


  private

  def create_chatroom
    build_chatroom.save
  end

  def calculate_billing_amount
    puts "Calculating billing amount for #{booking_dog_profiles.count} profiles..."
    
    # If no profiles or no duration, set the amount to 0
    unless booking_dog_profiles.any? && duration.is_a?(Numeric)
      self.amount = 0
      return
    end

    total_amount = 0

    booking_dog_profiles.each do |booking_dog_profile|
      dog_profile = booking_dog_profile.dog_profile
      weight = dog_profile.weight
      job = dog_walking_job
      puts "Dog Profile: #{dog_profile.name}, Weight: #{weight}"

      if weight < 20
        rate = job.wgr1
      elsif weight < 60
        rate = job.wgr2
      else
        rate = job.wgr3
      end

      total_amount += self.duration * rate
      puts "Rate: #{rate}, Total Amount: #{total_amount}"
    end

    self.amount = total_amount
  end

  
end
