FactoryGirl.define do
  factory :upload do
    association :user, :factory => :user
  end
end