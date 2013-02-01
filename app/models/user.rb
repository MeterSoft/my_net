class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :msg => "15x15" },
                    :default_url => 'default_large.png'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :thread_name, :avatar

  has_many :friends

  acts_as_messageable

  searchable do
    text :first_name, :last_name
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end
end
