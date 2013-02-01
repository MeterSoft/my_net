class AddStatusAndPingToUser < ActiveRecord::Migration
  def change
    add_column :users, :status, :string, :default => "offline"
    add_column :users, :ping, :time
  end
end
