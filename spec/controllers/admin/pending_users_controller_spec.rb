require 'rails_helper'

RSpec.describe Admin::PendingUsersController, type: :controller do
  let(:admin) { create(:admin) }
  let(:pending_user) { create(:user) } # Assuming you have a pending trait in your user factory

  describe 'GET #index' do
    context 'when admin is authenticated' do
      before do
        # Assuming you have a method to authenticate admin in your test helper
        request.headers.merge!(admin.create_new_auth_token)
        get :index
      end

      it 'returns a list of pending users' do
        expect(response).to have_http_status(:ok)
        response_json = JSON.parse(response.body)
        expect(response_json).to be_a(Array)
      end
    end

    context 'when admin is not authenticated' do
      before do
        get :index
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    context 'when admin is authenticated' do
      before do
        request.headers.merge!(admin.create_new_auth_token)
        get :show, params: { id: pending_user.id }
      end

      it 'returns the pending user' do
        expect(response).to have_http_status(:ok)
        response_json = JSON.parse(response.body)
        expect(response_json['id']).to eq(pending_user.id)
      end
    end

    context 'when admin is not authenticated' do
      before do
        get :show, params: { id: pending_user.id }
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #update' do
    context 'when admin is authenticated' do
      before do
        request.headers.merge!(admin.create_new_auth_token)
      end

      context 'when user is pending' do
        before do
          put :update, params: { id: pending_user.id }
        end

        it 'approves the user and returns a success message' do
          expect(response).to have_http_status(:ok)
          response_json = JSON.parse(response.body)
          expect(response_json['message']).to eq('User approved')
        end
      end

      context 'when user is not pending' do
        let(:not_pending_user) { create(:user, status: 'approved') }

        before do
          put :update, params: { id: not_pending_user.id }
        end

        it 'returns an error message' do
          expect(response).to have_http_status(422)
          response_json = JSON.parse(response.body)
          expect(response_json['error']).to eq('User is not pending')
        end
      end
    end

    context 'when admin is not authenticated' do
      before do
        put :update, params: { id: pending_user.id }
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
