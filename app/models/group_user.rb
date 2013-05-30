class GroupUser < ActiveRecord::Base
  attr_accessible :user_id, :group_id, :activate

  belongs_to :user
  belongs_to :group
end
