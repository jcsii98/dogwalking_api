class UsersSearchController < ApplicationController
    before_action :authenticate_user!

    def index
        # Get the search radius in kilometers from the request (default to 5km if not provided)
        search_radius = (params[:radius] || 5).to_f

        # Get the current user's location (you may need to implement this)
        user_location = current_user.cached_geocode

        # Perform the geospatial query to find users within the specified radius
        # Query users within the specified radius (in kilometers) of the current user's location
        nearby_users = User.near(user_location, search_radius, units: :km)

        # Return the search results as JSON
        render json: nearby_users
    end
end