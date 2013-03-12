class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :user_id
      t.string :url
      t.string :description
      t.string :title
      t.string :image
      t.string :image_medium
      t.datetime :date

      t.timestamps
    end
  end
end
