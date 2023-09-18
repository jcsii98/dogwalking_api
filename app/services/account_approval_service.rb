class AccountApprovalService
  def self.approve_user_account(user)
    user.update(status: "approved")
    UserMailer.account_approved(user).deliver_now
    true
  rescue StandardError => e
    Rails.logger.error("Error approving user account: #{e.message}")
    false
  end
end
