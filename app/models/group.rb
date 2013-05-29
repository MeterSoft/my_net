class Group < ActiveRecord::Base
  attr_accessible :group_name, :group_description, :user_id
end
