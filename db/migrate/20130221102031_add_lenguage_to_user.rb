class AddLenguageToUser < ActiveRecord::Migration
  def change
    add_column :users, :lenguage, :string, :default => "ru"
  end
end
