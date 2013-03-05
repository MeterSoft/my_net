class Poster < ActiveRecord::Base
  attr_accessible :message, :user_id

  belongs_to :user
  has_many :comments
end
