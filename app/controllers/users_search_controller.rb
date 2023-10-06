class UsersSearchController < ApplicationController
  before_action :authenticate_user!

  def index
    # Specify the radius in kilometers
    radius_in_km = params[:radius].to_f

    search_service = UsersSearchService.new(current_user)
    nearby_users = search_service.search_within_radius(radius_in_km)
    
    # Filter the results to only include the id, name, and distance attributes
    filtered_users = nearby_users.map do |user|
      {
        id: user[:id],
        name: user[:name],
        distance: user[:distance]
      }
    end
    puts "Filtered Users: #{filtered_users.inspect}"
    # Return the filtered results as JSON
    render json: filtered_users
  end
end