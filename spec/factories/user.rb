FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@factory.com"
  end
  factory :user do
    first_name 'test'
    last_name 'test'
    thread_name 'test'
    email
    password 'password'
  end
end