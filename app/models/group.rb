class Group < ActiveRecord::Base
  PRIVATE = 'private'
  PUBLIC = 'public'
  TYPE = [PUBLIC, PRIVATE]

  attr_accessible :group_name, :group_description, :admin_id, :group_type

  validates_presence_of :group_name, :group_description, :group_type

  has_many :users, through: :group_user
  has_many :group_user, :dependent => :delete_all
  has_many :posts

  def members
	  users
  end

  def include_user?(user)
  	users.include?(user)  	
  end

  def public?
    group_type == PUBLIC
  end

  def private?
    group_type == PRIVATE
  end
end
