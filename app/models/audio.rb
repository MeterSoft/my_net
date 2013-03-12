class Audio < ActiveRecord::Base
  attr_accessible :artist, :title, :url, :user_id

  belongs_to :user
end
