class UsersService
  def self.get_pending_users
    User.where(status: "pending")
  end

  def self.get_pending_user_by_id(id)
    User.find_by(id: id, status: "pending")
  end

  def self.get_all_users
    User.all
  end

  def self.get_user_by_id(id)
    User.find_by(id: id)
  end

  def self.response_user_attributes(user)
    {
      id: user.id,
      full_name: user.name,
      email: user.email,
      status: user.status
    }
  end
end
