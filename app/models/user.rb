class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, , :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable, :validatable
  has_attached_file :avatar,
                    :storage => :dropbox,
                    :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
                    :styles => { :medium => {:geometry => "300x300" },
                                 :small => {:geometry => "50x50#"} },
                    :default_url => '/assets/:style/default_large.png',
                    :dropbox_options => {
                        :path => proc { |style| "#{style}/#{id}_#{avatar.original_filename}"},
                        :unique_filename => true
                    }

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :thread_name, :avatar, :time, :status, :lenguage,
                  :crop_x, :crop_y, :crop_w, :crop_h, :provider, :uid, :ip_address, :latitude, :longitude,
                  :sex,:zip_code, :birthday, :country, :time_zone, :address, :city, :phone, :phone_secondary

  #attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  #after_update :reprocess_avatar, :if => :cropping?
    
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :foreign_key => "friend_id", :class_name => 'Friendship'
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :uploads
  has_many :created_posts, :foreign_key => "creator_id", :class_name => "Post"
  has_many :received_posts, :foreign_key => "receiver_id", :class_name => "Post"
  has_many :posts
  has_many :groups, :through => :group_user
  has_many :group_user, :dependent => :delete_all
  has_one  :setting

  acts_as_messageable

  acts_as_voter

  # scope section
  scope :search, ->(search, id) { where("(CONCAT_WS(' ', lower(first_name), lower(last_name)) LIKE ?)
                                      OR (CONCAT_WS(' ', lower(last_name), lower(first_name)) LIKE ?)",
                                      "%#{search.downcase}%", "%#{search.downcase}%").where('id != ?', id) }

  validates_presence_of :first_name, :last_name

  geocoded_by :ip_address
  after_validation :geocode


  # methods section

  def all_friends
    approved_friends + approved_inverse_friends
  end

  def approved_friends
    friends.where(friendships: { status: 'approved' })
  end

  def approved_inverse_friends
    inverse_friends.where(friendships: { status: 'approved' })
  end

  def pending_inverse_friends
    inverse_friends.where(friendships: { status: 'pending' })
  end

  def friend?(user)
    all_friends.include?(user)
  end

  def friend_invited?(user)
    pending_inverse_friends.include?(user)
  end


  def friendship_with(user)
    Friendship.where(user_id: id, friend_id: user.id).first ||
    Friendship.where(user_id: user.id, friend_id: id).first
  end

  #-------------------

  def avatar_url
    self.avatar.url(:small)
  end

  def full_name
    [first_name, last_name].compact.join(' ')
  end

  def its_i?(id)
    id == self.id
  end

  #def cropping?
  #  !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  #end
  #
  #def avatar_geometry(style = :original)
  #  @geometry ||= {}
  #  @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  #end


  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.find_by_provider_and_uid(auth.provider, auth.uid.to_s)
    user.skip_confirmation! if user
    unless user
      user = User.find_by_email(auth.info.email)
      user.skip_confirmation! if user
      unless user
        user = User.create(first_name: auth.extra.raw_info.first_name,
                           last_name: auth.extra.raw_info.last_name,
                           provider: auth.provider,
                           uid: auth.uid.to_s,
                           email: auth.info.email || auth.uid.to_s + "@facebook.com",
                           password: Devise.friendly_token[0,20],
                           avatar: open(auth.info.image)
        )
        user.skip_confirmation! if user
      end
    end
    user
  end

  def self.find_for_vkontakte_oauth(auth, signed_in_resource=nil)
    user = User.find_by_provider_and_uid(auth.provider, auth.uid.to_s)
    user.skip_confirmation! if user
    unless user
      user = User.find_by_email(auth.info.email)
      user.skip_confirmation! if user
      unless user
        user = User.create(first_name: auth.extra.raw_info.first_name,
                           last_name: auth.extra.raw_info.last_name,
                           thread_name: auth.extra.raw_info.nickname,
                           provider: auth.provider,
                           uid: auth.uid.to_s,
                           email: auth.info.email || auth.uid.to_s + "@vk.com",
                           password: Devise.friendly_token[0,20],
                           avatar: open(auth.extra.raw_info.photo_big)
        )
        user.skip_confirmation! if user
        #vk = VkontakteApi::Client.new(auth.credentials.token)
        #
        #photos =  vk.photos.getAll
        #if photos != []
        #  photos[1..-1].each do |p|
        #    Photo.create(user_id: user.id, url: p.src, url_big: p.src_big, url_small: p.src_small)
        #  end
        #end

        #audios =  vk.audio.get
        #if audios != []
        #  audios[1..-1].each do |a|
        #    Audio.create(user_id: user.id, artist: a.artist, title: a.title, url: a.url)
        #  end
        #end

        #videos =  vk.video.get
        #if videos != []
        #  videos[1..-1].each do |v|
        #    Video.create(user_id: user.id, description: v.description, title: v.title, url: v.player, image: v.image, date: v.date)
        #  end
        #end
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

  def skip_confirmation!
    self.confirmed_at = Time.now
  end

  def created_groups
    groups.where(admin_id: id)
  end

  def member_of_groups
    groups.where('admin_id != ?', id)
  end

  def unconnected_groups
    Group.all - created_groups - member_of_groups
  end

  def admin?(group)
    group.admin_id == id
  end

  private

  def reprocess_avatar
    avatar.reprocess!
  end
end
