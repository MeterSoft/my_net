class Photo < ActiveRecord::Base
  attr_accessible :url, :url_big, :url_small, :user_id

  belongs_to :user
end
