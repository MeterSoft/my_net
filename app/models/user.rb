class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable
  has_attached_file :avatar,
                    :styles => { :medium => {:geometry => "300x300" },
                                 :small => {:geometry => "40x40#", :processors => [:cropper]},
                                 :large => {:geometry => "600x600>" } },
                    :default_url => '/assets/:style/default_large.png'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :thread_name, :avatar, :time, :status, :lenguage,
                  :crop_x, :crop_y, :crop_w, :crop_h, :provider, :uid

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_avatar, :if => :cropping?

  has_many :friends, :foreign_key => "user_id", :class_name => "Friend"
  has_many :inverse_friends, :foreign_key => "user_friend_id", :class_name => "Friend"
  has_many :uploads
  has_many :posters, order: 'created_at desc'
  has_many :videos
  has_many :photos
  has_many :audios

  acts_as_messageable

  validates_presence_of :first_name, :last_name

  searchable do
    text :first_name, :last_name
    integer :id
  end

  def avatar_url
    self.avatar.url(:small)
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def its_i?(id)
    id == self.id
  end

  def friend?(current_user)
    Friend.find_by_user_id_and_user_friend_id_and_status(self, current_user, 'confirmed') ||
    Friend.find_by_user_id_and_user_friend_id_and_status(current_user, self, 'confirmed')
  end

  def friend_invited?(current_user)
    Friend.find_by_user_id_and_user_friend_id_and_status(self, current_user, 'invite') ||
    Friend.find_by_user_id_and_user_friend_id_and_status(current_user, self, 'invite')
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.find_by_provider_and_uid(auth.provider, auth.uid)
    unless user
      user = User.find_by_email(auth.info.email)
      unless user
        user = User.create(first_name: auth.extra.raw_info.first_name,
                           last_name: auth.extra.raw_info.last_name,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: auth.info.email,
                           password: Devise.friendly_token[0,20],
                           avatar: open(auth.info.image)
        )
      end
    end
    user
  end

  def self.find_for_vkontakte_oauth(auth, signed_in_resource=nil)
    user = User.find_by_provider_and_uid(auth.provider, auth.uid)
    unless user
      user = User.find_by_email(auth.info.email)
      unless user
        user = User.create(first_name: auth.extra.raw_info.first_name,
                           last_name: auth.extra.raw_info.last_name,
                           thread_name: auth.extra.raw_info.nickname,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: auth.info.email || auth.uid.to_s + "@vk.com",
                           password: Devise.friendly_token[0,20],
                           avatar: open(auth.extra.raw_info.photo_big)
        )

        vk = VkontakteApi::Client.new(auth.credentials.token)

        photos =  vk.photos.getAll
        photos[1..-1].each do |p|
          Photo.create(user_id: current_user, url: p.src, url_big: p.src_big, url_small: p.src_small)
        end

        audios =  vk.audio.get
        audios[1..-1].each do |a|
          Audio.create(user_id: current_user, artist: a.artist, title: a.title, url: a.url)
        end

        videos =  vk.video.get
        videos[1..-1].each do |v|
          Video.create(user_id: current_user, description: v.description, title: v.title, url: v.player, image: v.image, date: v.date)
        end
      end
    end
    user
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  private

  def reprocess_avatar
    avatar.reprocess!
  end
end
