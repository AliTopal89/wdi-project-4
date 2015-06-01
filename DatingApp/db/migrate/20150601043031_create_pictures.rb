class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :image_url
      t.string :caption
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
