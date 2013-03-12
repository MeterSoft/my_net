class Video < ActiveRecord::Base
  attr_accessible :date, :description, :image, :image_medium, :title, :url, :user_id

  belongs_to :user
end
