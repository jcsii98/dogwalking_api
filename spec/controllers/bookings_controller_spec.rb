require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  describe 'GET #index' do
      let(:user_owner) { create(:user, kind: '2', name: 'Joe') }
      let(:dog_profile) { create(:dog_profile, name: 'Nala') }
      let(:booking) { create(:booking, user: user_owner, user_owner_name: user_owner.name, user_walker_name: user_walker.name, user_owner: user_owner, user_walker: user_walker, amount: '1000', dog_walking_job: dog_walking_job) }
      let!(:booking_dog_profile) { create(:booking_dog_profile, booking: booking, dog_profile: dog_profile) }
      let(:user_walker) { create(:user, kind: '1', name: 'Jay') }
      let(:dog_walking_job) { create(:dog_walking_job, user: user_walker) }

    context 'when user kind is 2' do

      before do
        request.headers.merge!(user_owner.create_new_auth_token)
      end

      it 'returns user bookings' do
        get :index

        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body).length).to eq(1)
        expect(response_json.first['id']).to eq(booking.id)
      end
    end

    context 'when user kind is not 2' do

      before do
        request.headers.merge!(user_walker.create_new_auth_token)
      end

      it 'returns bookings associated with dog walking job' do
        get :index, params: { dog_walking_job_id: dog_walking_job.id }
        
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(:success)
        expect(response_json.first['id']).to eq(booking.id)
      end

      it 'returns error when no dog walking job found' do
        get :index

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("You are not associated with any dog_walking_job.")
      end
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user, kind: '2') }
 
    let(:valid_params) { { booking: { dog_walking_job_id: dog_walking_job.id, amount: '0' } } }
    let(:invalid_params) { { booking: { dog_walking_job_id: 'invalid' } } }

    let(:user_walker) { create(:user, kind: '1') }
    let(:dog_walking_job) { create(:dog_walking_job, user: user_walker) }

    before do
      request.headers.merge!(user.create_new_auth_token)
    end

    context 'with valid params' do
      it 'creates a booking for the current user' do
        post :create, params: valid_params
        response_json = JSON.parse(response.body)

        expect(response).to have_http_status(201)
        expect(response_json['user_id']).to eq(user.id)
        expect(response_json['amount']).to eq('0.0')
      end
    end
    context 'with invalid_params' do
      it 'returns an error' do
        post :create, params: invalid_params

        response_json = JSON.parse(response.body)

        expect(response_json['error']).not_to be_empty
      end
    end
  end

  describe 'GET #show' do
    let(:user_owner) { create(:user, kind: '2') }
    let(:dog_profile) { create(:dog_profile, name: 'Nala') }
    let(:booking) { create(:booking, user: user_owner, user_owner_name: user_owner.name, user_walker_name: user_walker.name, user_owner: user_owner, user_walker: user_walker, amount: '1000', dog_walking_job: dog_walking_job) }
    let!(:booking_dog_profile) { create(:booking_dog_profile, booking: booking, dog_profile: dog_profile) }
    let(:user_walker) { create(:user, kind: '1') }
    let(:dog_walking_job) { create(:dog_walking_job, user: user_walker) }
    
    before do
      request.headers.merge!(user_owner.create_new_auth_token)
      get :show, params: { id: booking.id }
    end

    it 'returns the selected booking' do
      response_json = JSON.parse(response.body)
      expect(response_json['booking']['id']).to eq(booking.id)
    end
  end

  describe 'PUT #update' do
    let(:user_owner) { create(:user, kind: '2') }
    let(:user_walker) { create(:user, kind: '1') }

    # Create a dog walking job before using it to create the booking
    let!(:dog_walking_job) { create(:dog_walking_job, user: user_walker) }

     # Define dog_profile here
    let(:dog_profile) { create(:dog_profile, name: 'Buddy', breed: 'Golden Retriever', age: 2, sex: 'Male', weight: 70, user: user_owner) }

    # Create a booking associated with user_owner and user_walker
    let(:booking) { create(:booking, user: user_owner, user_owner: user_owner, user_walker: user_walker, duration: '1', dog_walking_job: dog_walking_job) }

    # Use the booking in your booking_dog_profile creation
    let!(:booking_dog_profile) { create(:booking_dog_profile, booking: booking, dog_profile: dog_profile) }

    let(:valid_params) { { booking: { duration: '2' } } }
    let(:invalid_params) { { booking: { duration: 'invalid' } } }

    before do
      booking.save!
      puts "Initial amount: #{booking.amount.to_f}"
      request.headers.merge!(user_owner.create_new_auth_token)
    end

    context 'with valid params' do

      before do
        put :update, params: { id: booking.id }.merge(valid_params)
      end

      it 'updates the values of the booking' do
        booking.reload

        expect(response).to have_http_status(200)
        expect(booking.amount.to_f).to eq(600)
        
      end
    end

    context 'with invalid_params' do
      before do
        put :update, params: { id: booking.id }.merge(invalid_params)
      end

      it 'does not update the values of the booking' do
        booking.reload

        expect(booking.amount.to_f).to eq(300)
        expect(response).to have_http_status(422)
      end
    end

    context 'when adding dog_profiles' do
      let(:dog_profile_3) { create(:dog_profile, name: 'Riley', weight: '10') }

      before do
        create(:booking_dog_profile, booking: booking, dog_profile: dog_profile_3)
      end

      it 'updates the values of the booking with the additional dog profile' do
        booking.reload
        puts "Number of booking_dog_profiles: #{booking.booking_dog_profiles.count}"

        booking.save!

        expected_amount = 400
        
        expect(booking.amount.to_f).to eq(expected_amount)
      end
    end

    context 'when removing a dog_profile from the booking' do
    let(:dog_profile_2) { create(:dog_profile, name: 'Theo', breed: 'Golden Retriever', age: 2, sex: 'Male', weight: 70, user: user_owner) }
    let!(:booking_dog_profile_2) { create(:booking_dog_profile, booking: booking, dog_profile: dog_profile_2) }
      before do
        booking_dog_profile_2.destroy
        booking.reload
        booking.save!
      end

      it 'recalculates the values of the booking' do
        expect(booking.booking_dog_profiles.count).to eq(1)
        expected_amount = 300

        expect(booking.amount.to_f).to eq(expected_amount)
      end
    end
  end

  describe 'DELETE #destroy' do
      let(:user_owner) { create(:user, kind: '2', name: 'Joe') }
      let(:dog_profile) { create(:dog_profile, name: 'Nala') }
      let(:booking) { create(:booking, user: user_owner, user_owner_name: user_owner.name, user_walker_name: user_walker.name, user_owner: user_owner, user_walker: user_walker, amount: '1000', dog_walking_job: dog_walking_job) }
      let!(:booking_dog_profile) { create(:booking_dog_profile, booking: booking, dog_profile: dog_profile) }
      let(:user_walker) { create(:user, kind: '1', name: 'Jay') }
      let(:dog_walking_job) { create(:dog_walking_job, user: user_walker) }
    before do
      request.headers.merge!(user_owner.create_new_auth_token)
      delete :destroy, params: { id: booking.id }
    end
    it 'archives a booking' do
      json_response = JSON.parse(response.body)

      expect(json_response['status']).to eq('success')
      expect(json_response['message']).to eq('Booking has been deleted')
      
      expect(response).to have_http_status(200)
    end
  end
end
