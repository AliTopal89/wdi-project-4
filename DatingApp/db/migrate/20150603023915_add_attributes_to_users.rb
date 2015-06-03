class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birthday, :datetime
    add_column :users, :is_female, :boolean, default: false 
  end
end
