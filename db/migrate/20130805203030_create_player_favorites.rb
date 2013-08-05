class CreatePlayerFavorites < ActiveRecord::Migration
  def change
    create_table :player_favorites do |t|
      t.integer :user_id
      t.integer :player_id

      t.timestamps
    end
  end
end
