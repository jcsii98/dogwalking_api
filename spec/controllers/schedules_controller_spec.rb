# require 'rails_helper'

# RSpec.describe SchedulesController, type: :controller do
#     describe 'GET #index' do
#         let(:user_walker_1) { create(:user, kind: "1") }
#         let(:dog_walking_job) { create(:dog_walking_job, user: user_walker_1) }
#         let!(:schedule) { create(:schedule, dog_walking_job: dog_walking_job) }
#         let!(:schedule_hidden) { create(:schedule, dog_walking_job: dog_walking_job, hidden: 'true', day: '2') }
#         context 'when a user is authenticated and is the job owner' do
#             before do
#                 request.headers.merge!(user_walker_1.create_new_auth_token)
#                 get :index, params: { dog_walking_job_id: dog_walking_job.id }
#             end

#             it 'returns a 200 status code' do
#                 expect(response).to have_http_status(200)
#             end

#             it 'returns the schedules including hidden for the dog-walking job' do
#                 response_json = JSON.parse(response.body)

#                 expect(response_json['data'].count).to eq(2)
#             end
#         end
#         context 'when a user is authenticated as a walker but does not own the job' do
#             let(:user_walker_2) { create(:user, kind: "1") }
#             before do
#                 request.headers.merge!(user_walker_2.create_new_auth_token)
#                 get :index, params: { dog_walking_job_id: dog_walking_job.id }
#             end

#             it 'returns a 401 status code and return an error' do
#                 errors_json = JSON.parse(response.body)

#                 expect(errors_json['message']).not_to be_empty
#                 expect(response).to have_http_status(401)
#             end
#         end
#         context 'when a user is authenticated with kind 2' do
#             let(:user_owner_1) { create(:user, kind:'2') }
#             before do
#                 request.headers.merge!(user_owner_1.create_new_auth_token)
#                 get :index, params: { dog_walking_job_id: dog_walking_job.id }
#             end

#             it 'returns a status code 200' do
#                 expect(response).to have_http_status(200)
#             end

#             it 'returns the schedules that have hidden set to false' do
#                 response_json = JSON.parse(response.body)

#                 expect(response_json['data'].count).to eq(1)
#                 expect(response_json['data'].first['id']).to eq(schedule.id)
#             end
#         end
#     end

#     describe 'POST #create' do
#         let(:user_walker_1) { create(:user, kind: "1") }
#         let(:dog_walking_job) { create(:dog_walking_job, user: user_walker_1) }
#         let(:valid_schedule_attributes) { attributes_for(:schedule) }
#         context 'when the user is authenticated as the owner of the job' do
#             before do
#                 request.headers.merge!(user_walker_1.create_new_auth_token)
#             end
#             context 'with valid params' do
#                 before do 
#                     post :create, params: { dog_walking_job_id: dog_walking_job.id, schedule: valid_schedule_attributes }
#                 end
#                 it 'creates a new schedule' do
#                     expect(Schedule.count).to eq(1)
#                 end
#                 it 'returns a success message' do
#                     expect(response).to have_http_status(200)
#                     expect(JSON.parse(response.body)['status']).to eq('success')
#                 end
#             end
#             context 'with invalid params' do
#                 let(:invalid_schedule_attributes) { { day: nil, start_time: nil, end_time: nil, hidden: nil } }
#                 before do
#                     post :create, params: { dog_walking_job_id: dog_walking_job.id, schedule: invalid_schedule_attributes }
#                 end
#                 it 'returns an error' do
#                     errors_json = JSON.parse(response.body)

#                     expect(response).to have_http_status(422)
#                     expect(errors_json['errors']).not_to be_empty
#                 end
#                 it 'does not create a new schedule' do
#                     expect(Schedule.count).to eq(0)
#                 end
#             end
#         end

#         context 'when the user is not authenticated' do
#             before do
#                 post :create, params: { dog_walking_job_id: dog_walking_job.id, schedule: valid_schedule_attributes }
#             end

#             it 'returns an error' do
#                 errors_json = JSON.parse(response.body)

#                 expect(errors_json['errors']).not_to be_empty
#                 expect(response).to have_http_status(401)
#             end
#         end

#         context 'when the user is not the owner of the job and has a kind of 1' do
#             let(:user_walker_2) { create(:user, kind: '1') }
#             before do
#                 request.headers.merge!(user_walker_2.create_new_auth_token)
#                 post :create, params: { dog_walking_job_id: dog_walking_job.id, schedule: valid_schedule_attributes }
#             end
#             it 'does not create the schedule' do
#                 expect(Schedule.count).to eq(0)
#             end
#             it 'returns an error' do
#                 errors_json = JSON.parse(response.body)

#                 expect(response).to have_http_status(401)
#                 expect(errors_json['message']).not_to be_empty
#             end
#         end
#         context 'when the user has a wrong kind' do
#             let(:user_owner_1) { create(:user, kind: '2') }
#             before do
#                 request.headers.merge!(user_owner_1.create_new_auth_token)

#                 post :create, params: { dog_walking_job_id: dog_walking_job.id, schedule: valid_schedule_attributes }
#             end

#             it 'returns an error' do
#                 errors_json = JSON.parse(response.body)

#                 expect(errors_json['message']).not_to be_empty
#                 expect(response).to have_http_status(401)
#             end

#             it 'does not create a schedule' do
#                 expect(Schedule.count).to eq(0)
#             end
#         end
#     end

#     describe 'GET #show' do
#         let(:user_walker_1) { create(:user, kind: "1") }
#         let(:user_owner_1) { create(:user, kind: '2') }
#         let(:dog_walking_job) { create(:dog_walking_job, user: user_walker_1) }
#         let!(:schedule) { create(:schedule, dog_walking_job: dog_walking_job) }
#         let!(:schedule_hidden) { create(:schedule, dog_walking_job: dog_walking_job, hidden: 'true', day: '2') }
#         context 'when job owner is authenticated' do
#             before do
#                 request.headers.merge!(user_walker_1.create_new_auth_token)
#                 get :show, params: { dog_walking_job_id: dog_walking_job.id, id: schedule.id }
#             end

#             it 'responds with the schedule' do
#                 response_json = JSON.parse(response.body)

#                 expect(response).to have_http_status(200)
#                 expect(response_json['data']['id']).to eq(schedule.id)
#             end
#         end
#         context 'when a user owner is authenticated' do
#             before do
#                 request.headers.merge!(user_owner_1.create_new_auth_token)
#             end
            
#             context 'when the schedule is hidden' do
#                 before do
#                     get :show, params: { dog_walking_job_id: dog_walking_job.id, id: schedule_hidden.id }
#                 end
#                 it 'does not show the schedule' do
#                     response_json = JSON.parse(response.body)

#                     expect(response_json['status']).to eq('error')
#                     expect(response_json['message']).to eq('schedule not found')
#                 end
#             end

#             context 'when the schedule is not hidden' do
#                 before do
#                     get :show, params: { dog_walking_job_id: dog_walking_job.id, id: schedule.id }
#                 end
#                 it 'responds with the schedule' do
#                     response_json = JSON.parse(response.body)

#                     expect(response).to have_http_status(200)
#                     expect(response_json['data']['id']).to eq(schedule.id)
#                 end
#             end
#         end

#         context 'when a user_walker is authenticated but is not the owner' do
#             let(:user_walker_2) { create(:user, kind: '1') }
#             before do
#                 request.headers.merge!(user_walker_2.create_new_auth_token)
#                 get :show, params: { dog_walking_job_id: dog_walking_job.id, id: schedule.id }
#             end

#             it 'returns an error' do
#                 errors_json = JSON.parse(response.body)

#                 expect(errors_json['status']).to eq('error')
#                 expect(errors_json['message']).not_to be_empty
#             end
#         end
#     end

#     describe 'PATCH #update' do
#         let(:user_walker_1) { create(:user, kind: "1") }
#         let(:dog_walking_job) { create(:dog_walking_job, user: user_walker_1) }
#         let!(:schedule) { create(:schedule, dog_walking_job: dog_walking_job, day: '1') }
#         let(:valid_schedule_attributes) { { day: '2' } }
#         let(:invalid_schedule_attributes) { { day: 'invalid_day' } }
#         context 'when the owner is authenticated' do
#             before do
#                 request.headers.merge!(user_walker_1.create_new_auth_token)
#             end
#             context 'with valid params' do
#                 before do
#                     patch :update, params: { dog_walking_job_id: dog_walking_job.id, id: schedule.id, schedule: valid_schedule_attributes }
#                 end
#                 it 'returns a 200 status code' do
#                     expect(response).to have_http_status(200)
#                 end
#                 it 'updates the schedule details' do
#                     json_response = JSON.parse(response.body)

#                     expect(json_response['data']['day']).to eq(2)
#                 end
#             end

#             context 'with invalid_params' do
#                 before do
#                     patch :update, params: { dog_walking_job_id: dog_walking_job.id, id: schedule.id, schedule: invalid_schedule_attributes }
#                 end
#                 it 'returns a 422 status' do
#                     expect(response).to have_http_status(422)
#                 end
#                 it 'returns an error' do
#                     errors_json = JSON.parse(response.body)

#                     expect(errors_json['errors']).not_to be_empty
#                 end
#             end
#         end

#         context 'when a different walker is authenticated' do
#             let(:user_walker_2) { create(:user, kind: '1') }
#             before do
#                 request.headers.merge!(user_walker_2.create_new_auth_token)
#                 patch :update, params: { dog_walking_job_id: dog_walking_job.id, id: schedule.id, schedule: valid_schedule_attributes }
#             end
#             it 'returns an error' do
#                 errors_json = JSON.parse(response.body)

#                 expect(errors_json['message']).not_to be_empty
#                 expect(response).to have_http_status(401)
#             end
#         end
#     end

#     describe 'DELETE #destroy' do
#         let(:user_walker_1) { create(:user, kind: "1") }
#         let(:dog_walking_job) { create(:dog_walking_job, user: user_walker_1) }
#         let!(:schedule) { create(:schedule, dog_walking_job: dog_walking_job, day: '1') }
#         context 'when the owner is authenticated' do
#             before do
#                 request.headers.merge!(user_walker_1.create_new_auth_token)
#                 delete :destroy, params: { dog_walking_job_id: dog_walking_job.id, id: schedule.id }
#             end
#             it 'deletes the schedule' do
#                 response_json = JSON.parse(response.body)
                
#                 expect(response).to have_http_status(200)
#                 expect(response_json['status']).to eq('success')
#                 expect(response_json['message']).to eq('schedule deleted')
#             end
#         end

#         context 'when a different walker is authenticated' do
#             let(:user_walker_2) { create(:user, kind: '1') }
#             before do
#                 request.headers.merge!(user_walker_2.create_new_auth_token)
#                 delete :destroy, params: { dog_walking_job_id: dog_walking_job.id, id: schedule.id }
#             end
#             it 'returns an error' do
#                 errors_json = JSON.parse(response.body)

#                 expect(errors_json['message']).not_to be_empty
#                 expect(response).to have_http_status(401)
#             end
#         end
#     end
# end