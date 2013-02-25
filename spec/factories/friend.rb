FactoryGirl.define do
  factory :friend do
    association :user, factory: :user
  end
end