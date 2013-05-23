class Setting < ActiveRecord::Base
  attr_accessible :birthday, :zip_code, :country, :city,
  				  :address, :phone, :phone_secondary, :user_id

  belongs_to :user
end
