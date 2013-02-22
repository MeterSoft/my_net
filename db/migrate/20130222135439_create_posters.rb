class CreatePosters < ActiveRecord::Migration
  def change
    create_table :posters do |t|
      t.integer :user_id
      t.text :message

      t.timestamps
    end
  end
end
