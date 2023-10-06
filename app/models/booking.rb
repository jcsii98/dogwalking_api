class Booking < ApplicationRecord
  belongs_to :dog_walking_job
  belongs_to :user

  belongs_to :user_owner, class_name: 'User', foreign_key: 'user_owner_id'
  belongs_to :user_walker, class_name: 'User', foreign_key: 'user_walker_id'

  has_many :booking_dog_profiles, dependent: :destroy, after_remove: :recalculate_billing_amount
  has_many :dog_profiles, through: :booking_dog_profiles
  has_one :chatroom, dependent: :destroy

  after_create :create_chatroom

  accepts_nested_attributes_for :booking_dog_profiles, allow_destroy: true

  
  # Calculate the billing amount before validations but only if duration is present.
  before_save :calculate_billing_amount, if: -> { duration.present? }

  validates :duration, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true


  private

  def create_chatroom
    build_chatroom.save
  end

  def recalculate_billing_amount(removed_profile)
    puts "Recalculating billing amount..."
    calculate_billing_amount
  end

  def calculate_billing_amount
    puts "Calculating billing amount for #{booking_dog_profiles.count} profiles..."
    return unless booking_dog_profiles.any?
    return unless duration.is_a?(Numeric)

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
