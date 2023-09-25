FactoryBot.define do
  factory :schedule do
    association :dog_walking_job, factory: :dog_walking_job
    day { 1 }
    start_time { "2023-09-18 13:01:38" }
    end_time { "2023-09-18 13:01:38" }
  end
end
