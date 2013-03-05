class Comment < ActiveRecord::Base
  attr_accessible :comment, :poster_id

  belongs_to :poster
end
