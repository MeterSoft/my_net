class AddProfileColumtToUser < ActiveRecord::Migration
  def change
  	add_column :users, :sex, :string
  	add_column :users, :birthday, :date
  	add_column :users, :zip_code, :integer
  	add_column :users, :country, :string
  	add_column :users, :time_zone, :string, :default => "UTC"
  	add_column :users, :city, :string
  	add_column :users, :address, :string
  	add_column :users, :phone, :integer	
  	add_column :users, :phone_secondary, :integer
  end
end