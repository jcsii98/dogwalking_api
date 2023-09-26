require 'rails_helper'

RSpec.describe UsersController, type: :controller do
    describe 'GET #show' do
        context 'when a user is authenticated' do
            let(:user) { create(:user) }
            

            it 'responds with a 200 status code' do
                request.headers.merge!(user.create_new_auth_token)
                get :show
                expect(response).to have_http_status(200)
            end

            it 'returns the current user as JSON' do
                user_json = JSON.parse(response.body)
                expect(user_json['id']).to eq(user.id)
                # Add more expectations as needed
            end
        end

        context 'when a user is not authenticated' do
            it 'responds with a 401 status code' do
                get :show
                expect(response).to have_http_status(401)
            end
        end
    end

    describe 'PATCH #update' do
        let(:user) { create(:user) }
        let(:valid_params) { { user: { name: 'New Name' } } }
        let(:invalid_params) { { user: { name: '' } } }

        context 'when a user is authenticated' do
        before { sign_in user }

        context 'with valid parameters' do
            before { patch :update, params: valid_params }

            it 'responds with a 200 status code' do
            expect(response).to have_http_status(200)
            end

            it 'returns the updated user as JSON' do
            user_json = JSON.parse(response.body)
            expect(user_json['name']).to eq('New Name')
            # Add more expectations as needed
            end
        end

        context 'with invalid parameters' do
            before { patch :update, params: invalid_params }

            it 'responds with a 422 status code' do
            expect(response).to have_http_status(422)
            end

            it 'returns errors as JSON' do
            error_json = JSON.parse(response.body)
            expect(error_json['errors']).not_to be_empty
            # Add more expectations as needed
            end
        end
        end

        context 'when a user is not authenticated' do
        it 'responds with a 401 status code' do
            patch :update, params: valid_params
            expect(response).to have_http_status(401)
        end
        end
    end
end