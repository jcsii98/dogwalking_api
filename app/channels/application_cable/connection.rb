module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      reject_unauthorized_connection unless self.current_user
    end

    private

    def find_verified_user
      uid = request.params[:uid]
      token = request.params['access-token']
      client_id = request.params[:client]

      user = User.find_by(uid: uid)

      if user && user.valid_token?(token, client_id)
        user
      else
        reject_unauthorized_connection
      end
    end
  end
end
