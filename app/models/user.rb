# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User

  before_save :geocode_address, if: :address_attributes_changed?

  has_many :dog_profiles

  has_one :dog_walking_job

  has_many :owner_bookings, class_name: 'Booking', foreign_key: 'user_owner_id'
  has_many :walker_bookings, class_name: 'Booking', foreign_key: 'user_walker_id'

  validates :name, presence: true, length: { minimum: 1 }
  validates :kind, inclusion: { in: %w(1 2), message: "must be '1' or '2'" }, if: -> { kind.present? }
  private
  
  def address_attributes_changed?
    %w(street_address city state country).any? { |attr| self.send("#{attr}_changed?") }
  end
  
  def geocode_address
    
    address = [street_address, city, state, country].compact.join(', ')
    Rails.logger.debug("Geocoding address... #{address}")
    
    coordinates = GeocodingService.geocode_location(address)

    if coordinates.key?(:error)
      errors.add(:base, 'Geocoding error: ' + coordinates[:error])
    else
      self.cached_geocode = "#{coordinates[:latitude]},#{coordinates[:longitude]}"
    end
    Rails.logger.debug("Geocoding completed.")
  end

end
