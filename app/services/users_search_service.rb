class UsersSearchService
  def initialize(user)
    @user = user
  end
  def haversine_distance(lat1, lon1, lat2, lon2)
    radius_of_earth_km = 6371.0

    dlat = (lat2 - lat1).to_rad
    dlon = (lon2 - lon1).to_rad

    a = Math.sin(dlat / 2)**2 + Math.cos(lat1.to_rad) * Math.cos(lat2.to_rad) * Math.sin(dlon / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

    radius_of_earth_km * c
  end
  def search_within_radius(radius)
    user_location = @user.cached_geocode
    degrees_per_km = 1 / 111.32

    lat_min = user_location.split(',')[0].to_f - (radius * degrees_per_km)
    lat_max = user_location.split(',')[0].to_f + (radius * degrees_per_km)
    lon_min = user_location.split(',')[1].to_f - (radius * degrees_per_km)
    lon_max = user_location.split(',')[1].to_f + (radius * degrees_per_km)

    nearby_users = User.where(
      "CAST(SPLIT_PART(cached_geocode, ',', 1) AS FLOAT) BETWEEN ? AND ? AND CAST(SPLIT_PART(cached_geocode, ',', 2) AS FLOAT) BETWEEN ? AND ? AND kind != ? AND status != ?",
      lat_min, lat_max, lon_min, lon_max, @user.kind, 'pending'
    )

    user_lat = user_location.split(',')[0].to_f
    user_lon = user_location.split(',')[1].to_f

    nearby_users.map do |u|
      u_lat = u.cached_geocode.split(',')[0].to_f
      u_lon = u.cached_geocode.split(',')[1].to_f
      dist = haversine_distance(user_lat, user_lon, u_lat, u_lon)
      
      {
        id: u.id,
        name: u.name,
        distance: dist
      }
    end
  end
end

class Numeric
  def to_rad
    self * Math::PI / 180
  end
end