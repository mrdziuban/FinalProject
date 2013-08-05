class AddIndexes < ActiveRecord::Migration
  def change
    add_index :players, :team_abbrev
    add_index :goalies, :team_abbrev
    add_index :games, :home
    add_index :games, :away
    add_index :player_favorites, :user_id
    add_index :player_favorites, :player_id
    add_index :team_favorites, :team_abbrev
    add_index :team_favorites, :user_id
    add_index :teams, :abbrev
  end
end
