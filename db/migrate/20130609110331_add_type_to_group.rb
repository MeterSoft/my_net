class AddTypeToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :group_type, :string
  end
end
