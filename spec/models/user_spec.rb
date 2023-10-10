require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        email: 'user@example.com',
        password: 'password',
        kind: '1',
        name: 'John Appleseed'
      )
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user = User.new(
        password: 'password',
        kind: '1'
      )
      expect(user).to_not be_valid
    end

    it 'is not valid with an invalid kind' do
      user = User.new(
        email: 'user@example.com',
        password: 'password',
        kind: '3'
      )
      expect(user).to_not be_valid
    end
  end

  context 'associations' do
    it 'has many dog_profiles' do
      association = described_class.reflect_on_association(:dog_profiles)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many owner_bookings' do
      association = described_class.reflect_on_association(:owner_bookings)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many walker_bookings' do
      association = described_class.reflect_on_association(:walker_bookings)
      expect(association.macro).to eq(:has_many)
    end
  end

  context 'callbacks' do
    it 'geocodes address before save if address attributes changed' do
      # Stub the class method geocode_location of GeocodingService
      allow(GeocodingService).to receive(:geocode_location).and_return(
        latitude: 'latitude',
        longitude: 'longitude'
      )

      user = User.new(
        email: 'user@example.com',
        password: 'password',
        name: 'John Appleseed',
        street_address: '123 Main St',
        city: 'Random City',
        state: 'Random',
        country: 'PH'
      )

      user.save

      expect(user.cached_geocode).to eq('latitude,longitude')
    end
  end
end