class UsersSearchService
  def initialize(user)
    @user = user
  end

  def search_within_radius(radius)
    user_location = @user.cached_geocode
    degrees_per_km = 1 / 111.32

    lat_min = user_location.split(',')[0].to_f - (radius * degrees_per_km)
    lat_max = user_location.split(',')[0].to_f + (radius * degrees_per_km)
    lon_min = user_location.split(',')[1].to_f - (radius * degrees_per_km)
    lon_max = user_location.split(',')[1].to_f + (radius * degrees_per_km)

    # Filter users based on kind and exclude users with status = 'pending'
    User.where(
      "CAST(SPLIT_PART(cached_geocode, ',', 1) AS FLOAT) BETWEEN ? AND ? AND CAST(SPLIT_PART(cached_geocode, ',', 2) AS FLOAT) BETWEEN ? AND ? AND kind != ? AND status != ?",
      lat_min, lat_max, lon_min, lon_max, @user.kind, 'pending'
    )
  end
end