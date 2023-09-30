require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    context 'when admin is authenticated' do
      before do
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
        get :show, params: { id: user.id }
      end

      it 'returns the user' do
        expect(response).to have_http_status(:ok)
        response_json = JSON.parse(response.body)
        expect(response_json['id']).to eq(user.id)
      end
    end

    context 'when admin is not authenticated' do
      before do
        get :show, params: { id: user.id }
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
