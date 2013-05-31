class AddClientIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :client_id, :string
    add_column :users, :string, :string
  end
end
