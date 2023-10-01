require 'httparty'

class GeocodingService
  MAPBOX_API_URL = 'https://api.mapbox.com/geocoding/v5/mapbox.places/'

  def self.geocode_location(location)
    # Replace 'YOUR_MAPBOX_ACCESS_TOKEN' with your actual Mapbox access token
    access_token = 'pk.eyJ1IjoiamNzaWk5OCIsImEiOiJjbG1uNXJhMjUwbzJ4MnJwbmsyOXMzeHV5In0.-tU9mwYA1a7iN81veAtyYQ'
    
    # Encode the location string
    encoded_location = URI.encode_www_form_component(location)

    # Construct the API request URL
    url = "#{MAPBOX_API_URL}#{encoded_location}.json?access_token=#{access_token}&country=ph"

    begin
      response = HTTParty.get(url)
      data = JSON.parse(response.body)

      if data['features'].present?
        # Assuming you want to return the coordinates of the first result
        coordinates = data['features'][0]['geometry']['coordinates']
        { latitude: coordinates[1], longitude: coordinates[0] }
      else
        { error: 'Location not found' }
      end
    rescue HTTParty::ResponseError => e
      { error: "Geocoding error: #{e.response.body}" }
    rescue StandardError => e
      { error: "Geocoding error: #{e.message}" }
    end
  end
end