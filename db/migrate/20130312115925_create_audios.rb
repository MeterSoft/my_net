class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.integer :user_id
      t.string :url
      t.string :artist
      t.string :title

      t.timestamps
    end
  end
end
