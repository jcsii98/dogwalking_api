require 'rails_helper'

RSpec.describe ChatroomsController, type: :controller do
    let(:user_walker) { create(:user, kind: '1') }
    let(:user_owner) { create(:user, kind: '2') }
    let!(:dog_walking_job) { create(:dog_walking_job, user: user_walker) }
    let(:booking) { create(:booking, user_walker: user_walker, user_owner: user_owner) }
    let!(:message) { create(:message, chatroom_id: booking.chatroom.id, user: user_walker, content: 'Hi!') }
    describe 'GET #show' do
        context 'when an associated user is authenticated' do
            before do
                request.headers.merge!(user_owner.create_new_auth_token)
                get :show, params: { booking_id: booking.id }
            end

            it 'returns the chatroom and messages' do
                response_json = JSON.parse(response.body)

                expect(response_json['chatroom']['id']).to eq(booking.chatroom.id)
                expect(response_json['messages'].count).to eq(1)
                expect(response_json['messages'].first['content']).to eq('Hi!')
            end
        end

        context 'when a user is authenticated but not associated with the chatroom' do
            let(:user_not_associated) { create(:user, kind: '1') }
            before do
                request.headers.merge!(user_not_associated.create_new_auth_token)
                get :show, params: { booking_id: booking.id }
            end

            it 'returns an error' do
                errors_json = JSON.parse(response.body)

                expect(response).to have_http_status(403)
                expect(errors_json['error']).to eq("You're not permitted to view or interact with this chatroom")
            end
        end

        context 'when a user is associated but not authenticated' do
            before do
                get :show, params: { booking_id: booking.id }
            end

            it 'returns an error' do
                errors_json = JSON.parse(response.body)

                expect(response).to have_http_status(401)
                expect(errors_json['errors']).not_to be_empty
            end
        end
    end

    describe 'POST #create_message' do
        let(:valid_message_params) { { content: 'Hello Walker!' } }
        let(:invalid_message_params) { { content: '' } }
        context 'when a user is authenticated and associated' do
            before do
                request.headers.merge!(user_owner.create_new_auth_token)
            end
            context 'with valid params' do
                before do
                    post :create_message, params: { booking_id: booking.id, message: valid_message_params }
                end
                it 'creates a new message' do
                    response_json = JSON.parse(response.body)

                    expect(response).to have_http_status(201)
                    expect(response_json['content']).to eq('Hello Walker!')
                end
            end
            context 'with invalid params' do
                before do
                    post :create_message, params: { booking_id: booking.id, message: invalid_message_params }
                end

                it 'does not create a new message' do
                    errors_json = JSON.parse(response.body)

                    expect(response).to have_http_status(422)
                    expect(errors_json['content']).to include('is too short (minimum is 1 character)')
                end
            end
        end
    end
end
