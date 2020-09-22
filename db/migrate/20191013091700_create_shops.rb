class CreateShops < ActiveRecord::Migration[5.1]
  def change
    create_table :shops do |t|
      t.integer :user_id
      t.boolean :adimn, default: false, null: false

      t.string :name
      t.string :area
      t.string :menu
      t.string :price
      t.text :review
      t.string :address
      t.string :station
      t.string :opening_hour
      t.string :phone
      t.string :url
      

      t.timestamps
    end
  end
end
