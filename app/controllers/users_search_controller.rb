class UsersSearchController < ApplicationController
  before_action :authenticate_user!

  def index
    # Specify the radius in kilometers
    radius_in_km = params[:radius].to_f

    search_service = UsersSearchService.new(current_user)

    nearby_users = search_service.search_within_radius(radius_in_km)

    # Return the search results as JSON
    render json: nearby_users
  end
end