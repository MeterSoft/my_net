FactoryGirl.define do
  factory :friendship do
    association :user, factory: :user
  end
end