class AddPolymorphicFavorites < ActiveRecord::Migration
  def change
    drop_table :team_favorites
    drop_table :player_favorites
    drop_table :goalie_favorites

    create_table :favorites do |t|
      t.integer :user_id
      t.integer :favoritable_id
      t.string :favoritable_type

      t.timestamps
    end
  end
end
