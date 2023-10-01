require 'rails_helper'

RSpec.describe GeocodingService do
    describe '.geocode_location' do
        let(:location) { 'Manila' }
        let(:api_url) do
            encoded_location = URI.encode_www_form_component(location)
            "https://api.mapbox.com/geocoding/v5/mapbox.places/#{encoded_location}.json?access_token=pk.eyJ1IjoiamNzaWk5OCIsImEiOiJjbG1uNXJhMjUwbzJ4MnJwbmsyOXMzeHV5In0.-tU9mwYA1a7iN81veAtyYQ&country=ph"
        end

        context 'when the request is successful' do
            let(:response_body) do
                {
                    "features" => [
                        {
                            "geometry" => {
                                "coordinates" => [123.456, 78.901]
                            }
                        }
                    ]
                }.to_json
            end
            before do
                stub_request(:get, api_url).to_return(body: response_body, status: 200)
            end
            it 'returns the latitude and longitude' do
                expect(GeocodingService.geocode_location(location)).to eq({ latitude: 78.901, longitude: 123.456 })
            end
        end
        
        context 'when no location is found' do
            let(:response_body) do
                { "features" => [] }.to_json
            end

            before do
                stub_request(:get, api_url).to_return(body: response_body, status: 200)
            end

            it 'returns an error message' do
                expect(GeocodingService.geocode_location(location)).to eq({ error: 'Location not found' })
            end
        end

        context 'when there is a HTTParty::ExceptionWithResponse error' do
            let(:mocked_response) do
                instance_double(HTTParty::Response, body: 'API error', code: 500)
            end
            before do
                allow(HTTParty).to receive(:get).with(api_url).and_raise(HTTParty::ResponseError.new(mocked_response))
            end

            it 'returns a geocoding error with the response' do
                expect(GeocodingService.geocode_location(location)).to eq({ error: 'Geocoding error: API error' })
            end
        end

        context 'when there is a StandardError' do
            before do
                allow(JSON).to receive(:parse).and_raise(StandardError.new('Parsing error'))
                stub_request(:get, "https://api.mapbox.com/geocoding/v5/mapbox.places/Manila.json?access_token=pk.eyJ1IjoiamNzaWk5OCIsImEiOiJjbG1uNXJhMjUwbzJ4MnJwbmsyOXMzeHV5In0.-tU9mwYA1a7iN81veAtyYQ&country=ph").to_return(status: 200, body: "Some dummy response", headers: {})
            end

            it 'returns a geocoding error with the message' do
                expect(GeocodingService.geocode_location(location)).to eq({ error: 'Geocoding error: Parsing error' })
            end
        end
    end
end