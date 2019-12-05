class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :shop, foreign_key: true
      t.string :content
      t.integer :score

      t.timestamps
    end
  end
end
