FactoryBot.define do
  factory :dog_walking_job do
    name { Faker::Job.title }
    user
    wgr1 {100}
    wgr2 {200}
    wgr3 {300}
  end
end