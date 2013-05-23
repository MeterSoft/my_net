class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :birthday, default: true
      t.boolean :zip_code, default: true
      t.boolean :country, default: true
      t.boolean :city, default: true
      t.boolean :address, default: true
      t.boolean :phone, default: true
      t.boolean :phone_secondary, default: true
      t.integer :user_id
      t.timestamps
    end
  end
end
