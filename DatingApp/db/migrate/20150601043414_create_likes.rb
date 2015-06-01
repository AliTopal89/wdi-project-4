class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :match_score
      t.text :posts

      t.timestamps null: false
    end
  end
end
