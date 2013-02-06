class Friend < ActiveRecord::Base
  belongs_to :friend, :foreign_key => "user_id" , :class_name => "User"
  belongs_to :inverse_friend, :foreign_key => "user_friend_id" , :class_name => "User"

  attr_accessible :user_friend_id, :user_id, :status

end
