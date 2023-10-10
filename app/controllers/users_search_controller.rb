class UsersSearchController < ApplicationController
  before_action :authenticate_user!

  def index
    # Specify the radius in kilometers
    radius_in_km = params[:radius].to_f

    search_service = UsersSearchService.new(current_user)
    nearby_users = search_service.search_within_radius(radius_in_km)
    
    if nearby_users.is_a?(Hash) && nearby_users[:error]
      render json: { message: nearby_users[:error] }, status: :unprocessable_entity
    else
      # Filter the results to only include the id, name, and distance attributes
      filtered_users = nearby_users.map do |user|
        {
          id: user[:id],
          name: user[:name],
          distance: user[:distance]
        }
      end
      
      if filtered_users.empty?
        render json: { message: "No walkers found" }
      else
        render json: filtered_users
      end
    end
  end

end