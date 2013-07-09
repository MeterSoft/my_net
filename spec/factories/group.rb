FactoryGirl.define do
  factory :group do
    group_name 'test group'
    group_description 'test description'
    group_type Group::PUBLIC
  end
end
