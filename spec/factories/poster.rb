FactoryGirl.define do
  factory :poster do
    association :user, :factory => :user
  end
end