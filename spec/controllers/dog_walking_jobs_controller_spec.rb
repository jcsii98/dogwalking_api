require 'rails_helper'

RSpec.describe DogWalkingJobsController, type: :controller do
    describe 'GET #index' do
        context 'when a user is authenticated and has the correct kind' do
            let(:user) { create(:user, kind: '1') }
            let(:dog_walking_job_1) { build(:dog_walking_job, user: user) }
            let(:dog_walking_job_2) { build(:dog_walking_job, user: user) }

            before do
                dog_walking_job_1.save!
                dog_walking_job_2.save!
                request.headers.merge!(user.create_new_auth_token)
                get :index
            end

            it 'responds with a 200 status code' do
                expect(response).to have_http_status(200)
            end

            it 'returns a list of unarchived dog profiles as JSON' do
                dog_walking_jobs_json = JSON.parse(response.body)
                expect(dog_walking_jobs_json['data'].length).to eq(2)
                expect(dog_walking_job_1.user).to eq(user)
                expect(dog_walking_job_2.user).to eq(user)
            end
        end
        context 'when a user is not authenticated' do
            let(:user) { create(:user, kind: '1') }
            let(:dog_walking_job) { build(:dog_walking_job, user: user) }

            before do
                dog_walking_job.save
                get :index
            end

            it 'responds with a 401 status code' do
                expect(response).to have_http_status(401)
            end

            it 'responds with an error' do
                errors_json = JSON.parse(response.body)

                expect(errors_json['errors']).not_to be_empty
            end
        end

        context 'when a user is authenticated but has the wrong kind' do
            let(:user) { create(:user, kind: '2') }
            let(:dog_walking_job) { build(:dog_walking_job, user: user) }

            before do
                dog_walking_job.save
                request.headers.merge!(user.create_new_auth_token)
                get :index
            end

            it 'responds with a 403 status code' do
                expect(response).to have_http_status(403)
            end

            it 'responds with an error' do
                errors_json = JSON.parse(response.body)

                expect(errors_json).not_to be_empty
            end
        end
    end

    describe 'POST #create' do
        context 'when a user is authenticated and has the right kind' do
            let(:user) { create(:user, kind: '1') }
            let(:valid_params) do
                {
                    name: "Rover's Walk",
                    wgr1: 1,
                    wgr2: 1,
                    wgr3: 1,
                    hidden: false,
                    archived: false
                }
            end
            let(:invalid_params) { { name: nil } }
            
            before do
                request.headers.merge!(user.create_new_auth_token)
            end

            context 'with valid parameters' do
                before do
                    post :create, params: { dog_walking_job: valid_params }
                end

                it 'returns a 201 status code' do
                    expect(response).to have_http_status(201)
                end

                it 'creates a new dog-walking job' do
                    expect(DogWalkingJob.count).to eq(1)
                end

                it 'associates the job with the user' do
                    expect(DogWalkingJob.first.user).to eq(user)
                end
            end
            
            context 'with invalid parameters' do
                before do
                    post :create, params: { dog_walking_job: invalid_params }
                end

                it 'returns a 422 status code' do
                    expect(response).to have_http_status(422)
                end

                it 'does not create a new DogWalkingJob' do
                    expect(DogWalkingJob.count).to eq(0)
                end

                it 'returns an error message' do
                    error_response = JSON.parse(response.body)

                    expect(error_response['name']).to include("can't be blank") # adapt according to the actual error message
                end
            end
        end
        context 'when the user is not authenticated' do
            let(:user) { create(:user, kind: '1') }
            let(:valid_params) do
                {
                    name: "Rover's Walk",
                    wgr1: 1,
                    wgr2: 1,
                    wgr3: 1,
                    hidden: false,
                    archived: false
                }
            end

            before do
                post :create, params: { dog_walking_job: valid_params }
            end

            it 'returns a 401 status code' do
                expect(response).to have_http_status(401)
            end

            it 'returns an error' do
                errors_json = JSON.parse(response.body)

                expect(errors_json['errors']).not_to be_empty
            end

            it 'does not create a new DogWalkingJob' do
                expect(DogWalkingJob.count).to eq(0)
            end
        end

        context 'when the user is authenticated but has the wrong kind' do 
            let(:user) { create(:user, kind: '2') }
            let(:valid_params) do
                {
                    name: "Rover's Walk",
                    wgr1: 1,
                    wgr2: 1,
                    wgr3: 1,
                    hidden: false,
                    archived: false
                }
            end

            before do
                request.headers.merge!(user.create_new_auth_token)
                post :create, params: { dog_walking_job: valid_params }
            end

            it 'returns a 403 status code' do
                expect(response).to have_http_status(403)
            end

            it 'returns a message' do
                errors_json = JSON.parse(response.body)

                expect(errors_json['message']).not_to be_empty
            end

            it 'does not create a new DogWalkingJob' do
                expect(DogWalkingJob.count).to eq(0)
            end
        end
    end

    describe 'GET #show' do
        context 'when a user is authenticated and has the right kind' do
            let(:user) { create(:user, kind: '1') }
            let(:dog_walking_job_1) { build(:dog_walking_job, user: user) }
            let(:dog_walking_job_2) { build(:dog_walking_job, user: user) }

            before do
                dog_walking_job_1.save!
                dog_walking_job_2.save!
                request.headers.merge!(user.create_new_auth_token)
                get :show, params: { id: dog_walking_job_1.id }
            end

            it 'returns a 200 status code' do
                expect(response).to have_http_status(200)
            end

            it 'returns the dog walking job as JSON' do
                response_json = JSON.parse(response.body)

                expect(response_json['data']['id']).to eq(dog_walking_job_1.id)
            end
        end

        context 'when the user is not authenticated' do
            let(:user) { create(:user, kind: '1') }
            let(:dog_walking_job) { build(:dog_walking_job, user: user) }

            before do
                dog_walking_job.save!
                get :show, params: { id: dog_walking_job.id }
            end

            it 'returns a 401 status code' do
                expect(response).to have_http_status(401)
            end

            it 'returns an error' do
                errors_json = JSON.parse(response.body)

                expect(errors_json['errors']).not_to be_empty
            end
        end

        context 'when the user is authenticated but has the wrong kind' do
            let(:user) { create(:user, kind: '2') }
            let(:dog_walking_job) { build(:dog_walking_job, user: user) }

            before do
                dog_walking_job.save!
                request.headers.merge!(user.create_new_auth_token)
                get :show, params: { id: dog_walking_job.id }
            end

            it 'returns a 403 status code' do
                expect(response).to have_http_status(403)
            end

            it 'returns an error' do
                errors_json = JSON.parse(response.body)

                expect(errors_json['message']).not_to be_empty
            end
        end
    end

    #     context 'when a user is not authenticated' do
    #         it 'responds with a 401 status code' do
    #             get :index

    #             expect(response).to have_http_status(401)
    #         end
    #     end

    #     context 'when a user is authenticated but has the wrong kind' do
    #         let(:user) { create(:user, kind: '1') }

    #         before do
    #             request.headers.merge!(user.create_new_auth_token)
    #             get :index
    #         end

    #         it 'responds with a 403 status code' do
    #             expect(response).to have_http_status(403)
    #         end
    #     end
    # end

    # describe 'POST #create' do
    #     let(:valid_params) { { dog_profile: { name: 'Nala', breed: 'American Bully', age: '4', sex: 'F', weight: '60' } } }
    #     let(:invalid_params) { { dog_profile: { name: '' } } }
    #     context 'when a user is authenticated and has the correct kind' do
    #         let(:user) { create(:user, kind: '2') }

    #         before do
    #             request.headers.merge!(user.create_new_auth_token)
    #             post :create, params: valid_params
    #         end

    #         it 'response with a 201 status code' do
    #             expect(response).to have_http_status(201)
    #         end

    #         it 'returns the created dog profile' do
    #             dog_profile = JSON.parse(response.body)

    #             expect(dog_profile['name']).to eq('Nala')
    #         end
    #     end

    #     context 'when a user is not authenticated' do
    #         it 'responds with a 401 status code' do
    #             post :create, params: valid_params

    #             expect(response).to have_http_status(401)
    #         end
    #     end

    #     context 'when a user is authenticated but has the wrong kind' do
    #         let(:user) { create(:user, kind: '1') }

    #         before do
    #             request.headers.merge!(user.create_new_auth_token)
    #             post :create, params: valid_params
    #         end

    #         it 'responds with a 403 status code' do
    #             expect(response).to have_http_status(403)
    #         end
    #     end

    #     context 'when a user is authenticated and has the correct kind but has invalid params' do
    #         let(:user) { create(:user, kind: '2') }
    #         before do
    #             request.headers.merge!(user.create_new_auth_token)
    #             post :create, params: invalid_params
    #         end
            
    #         it 'responds with a 422 status code' do
    #             expect(response).to have_http_status(422)
    #         end

    #         it 'responds with an error' do
    #             error_json = JSON.parse(response.body)

    #             expect(error_json['errors']).not_to be_empty
    #         end
    #     end
    # end

    # describe 'GET #show' do
    #     let(:user) { create(:user, kind: '2') }
    #     let!(:dog_profile1) { create(:dog_profile, user: user, name: 'Nala') }
    #     context 'when a user is authenticated' do
    #         before do
    #             request.headers.merge!(user.create_new_auth_token)
    #             get :show, params: { id: dog_profile1.id }
    #         end

    #         it 'responds with 200 status code' do
    #             expect(response).to have_http_status(200)
    #         end

    #         it 'returns the dog profile as JSON' do
    #             response_json = JSON.parse(response.body)

    #             expect(response_json['data']['name']).to eq('Nala')
    #         end
    #     end
    #     context 'when a user is not authenticated' do
    #         before do
    #             get :show, params: { id: dog_profile1.id }
    #         end

    #         it 'returns a 422 status code' do
    #             expect(response).to have_http_status(401)
    #         end

    #         it 'returns an error' do
    #             error_json = JSON.parse(response.body)

    #             expect(error_json['errors']).not_to be_empty
    #         end
    #     end

    #     context 'when a user is authenticated but the dog_profile does not exist' do
    #         before do
    #             request.headers.merge!(user.create_new_auth_token)
    #             get :show, params: { id: dog_profile1.id + 1 }
    #         end

    #         it 'returns an error' do
    #             error_json = JSON.parse(response.body)

    #             expect(error_json['message']).to eq("Dog profile not found")
    #         end

    #         it 'returns a status code 404' do
    #             expect(response).to have_http_status(404)
    #         end
    #     end
    # end

    # describe 'PUT #update' do
    #     let(:user) { create(:user, kind: '2') }
    #     let(:dog_profile) { create(:dog_profile, user: user, name: 'Nala') }
    #     let(:updated_attributes) { { name: 'Updated Name', breed: 'Updated Breed' } }

    #     context 'when a user is authenticated' do
    #         before do
    #             request.headers.merge!(user.create_new_auth_token)
    #             put :update, params: { id: dog_profile.id, dog_profile: updated_attributes }
    #         end

    #         it 'responds with 200 status code' do
    #             expect(response).to have_http_status(200)
    #         end

    #         it 'returns with the updated values' do
    #             response_json = JSON.parse(response.body)

    #             expect(response_json['data']['name']).to eq('Updated Name')
    #             expect(response_json['data']['breed']).to eq('Updated Breed')
    #         end
    #     end
    # end

    # describe 'DELETE #destroy' do
        
    # end
end