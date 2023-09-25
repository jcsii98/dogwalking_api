FactoryBot.define do
  factory :dog_walking_job do
    association :user, factory: :user
    name { "MyString" }
    wgr1 { 1 }
    wgr2 { 1 }
    wgr3 { 1 }
    hidden { false }
  end
end
