require 'rails_helper'

RSpec.describe UsersSearchController, type: :controller do
  describe 'GET #index' do
    context 'when a user is authenticated' do
      let(:user) { create(:user) }

      before do
        sign_in user
      end

      it 'responds with a 200 status code' do
        get :index, params: { radius: 10 }
        expect(response).to have_http_status(200)
      end

      it 'returns nearby users as JSON' do
        nearby_users = [create(:user), create(:user), create(:user)]
        
        allow_any_instance_of(UsersSearchService).to receive(:search_within_radius).and_return(nearby_users)

        get :index, params: { radius: 10 }

 
        nearby_users_json = JSON.parse(response.body)
        expect(nearby_users_json).to be_an(Array)
        expect(nearby_users_json.length).to eq(nearby_users.length)
      end
    end

    context 'when a user is not authenticated' do
      it 'responds with a 401 status code' do
        get :index, params: { radius: 10 }
        expect(response).to have_http_status(401)
      end
    end
  end
end