FactoryBot.define do
  factory :dog_walking_job do
    association :user, factory: :user
    name { "MyString" }
    wgr1 { 1 }
    wgr2 { 10 }
    wgr3 { 100 }
    hidden { false }
    archived { false }
  end
end
