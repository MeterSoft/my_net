class Group < ActiveRecord::Base
  attr_accessible :group_name, :group_description, :admin_id

  has_many :users, through: :group_user
  has_many :group_user, :dependent => :delete_all
end
