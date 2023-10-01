require 'rails_helper'

RSpec.describe AccountApprovalService do
    describe '.approve_user_account' do
        let(:user) { create(:user, status: "pending") }

        context 'with a valid user' do
            before do
                allow(UserMailer).to receive_message_chain(:account_approved, :deliver_now)
            end

            it 'updates the user status to approved' do
                AccountApprovalService.approve_user_account(user)
                expect(user.reload.status).to eq("approved")
            end

            it 'sends out an account approved mailer' do
                mailer = double(deliver_now: true)
                expect(UserMailer).to receive(:account_approved).with(user).and_return(mailer)
                expect(mailer).to receive(:deliver_now)
                AccountApprovalService.approve_user_account(user)
            end

            it 'returns true' do
                expect(AccountApprovalService.approve_user_account(user)).to be_truthy
            end
        end

        context 'when there is an exception' do
            before do
                allow(user).to receive(:update).and_raise(StandardError.new("Some error"))
            end

            it 'logs an error' do
                expect(Rails.logger).to receive(:error).with("Error approving user account: Some error")
                AccountApprovalService.approve_user_account(user)
            end

            it 'returns false' do
                expect(AccountApprovalService.approve_user_account(user)).to be_falsey
            end
        end
    end
end
