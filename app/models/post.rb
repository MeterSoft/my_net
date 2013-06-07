class Post < ActiveRecord::Base
  REPLY_VIEW_COUNT = 4
  attr_accessible :message, :parent_id, :receiver_id, :creator_id, :user_id, :group_id
  acts_as_votable

  validates :message, presence: true

  belongs_to :creator, :foreign_key => "creator_id" , :class_name => "User"
  belongs_to :receiver, :foreign_key => "receiver_id" , :class_name => "User"
  belongs_to :user
  has_many :replies, class_name: 'Post', inverse_of: :parent, :dependent => :delete_all, :foreign_key => 'parent_id'
  belongs_to :parent, class_name: 'Post', inverse_of: :replies, :foreign_key => 'parent_id'
  belongs_to :group
end
