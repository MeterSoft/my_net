class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#", :msg => "15x15#" },
                    :default_url => 'default_large.png'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :thread_name, :avatar, :time, :status

  has_many :friends, :foreign_key => "user_id", :class_name => "Friend"
  has_many :inverse_friends, :foreign_key => "user_friend_id", :class_name => "Friend"

  acts_as_messageable

  searchable do
    text :first_name, :last_name
    integer :id
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def friend?
    Friend.find_by_user_friend_id(id) || Friend.find_by_user_id(id)
  end
end
