class CreateGoalieFavorites < ActiveRecord::Migration
  def change
    create_table :goalie_favorites do |t|
      t.integer :goalie_id
      t.integer :user_id

      t.timestamps
    end

    add_index :goalie_favorites, :goalie_id
    add_index :goalie_favorites, :user_id
  end
end
