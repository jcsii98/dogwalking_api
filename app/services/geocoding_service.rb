class GeocodingService
  def self.geocode_location(location)
    url = "https://api.mapbox.com/geocoding/v5/mapbox.places/#{URI.encode(location)}.json?access_token=#{ENV['MAPBOX_ACCESS_TOKEN']}"
    
    response = RestClient.get(url)
    data = JSON.parse(response.body)

    if data['features'].present?
      # Assuming you want to return the coordinates of the first result
      coordinates = data['features'][0]['geometry']['coordinates']
      { latitude: coordinates[1], longitude: coordinates[0] }
    else
      # Handle the case where no results were found
      { error: 'Location not found' }
    end
  end
end