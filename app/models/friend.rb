class Friend < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_friend_id, :user_id
end
