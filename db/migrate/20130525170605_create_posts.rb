class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :creator_id
      t.text :message
      t.integer :parent_id
      t.integer :receiver_id
      t.integer :user_id
      t.integer :group_id

      t.timestamps
    end
  end
end
