class DogWalkingJob < ApplicationRecord
    belongs_to :user
    has_many :schedules


    before_save :geocode_address, if: :address_attributes_changed?

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
