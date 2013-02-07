class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar,
                    :styles => { :medium => {:geometry => "300x300>" },
                                 :small => {:geometry => "100x100#", :processors => [:cropper]},
                                 :large => {:geometry => "600x600>" } },
                    :default_url => 'default_large.png'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :thread_name, :avatar, :time, :status,
                  :crop_x, :crop_y, :crop_w, :crop_h

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_avatar, :if => :cropping?

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

  def friend?(current_user)
    Friend.find_by_user_id_and_user_friend_id_and_status(self, current_user, 'confirmed') ||
    Friend.find_by_user_id_and_user_friend_id_and_status(current_user, self, 'confirmed')
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end

  private

  def reprocess_avatar
    avatar.reprocess!
  end
end
