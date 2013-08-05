class CreateTeamFavorites < ActiveRecord::Migration
  def change
    create_table :team_favorites do |t|
      t.integer :user_id
      t.string :team_abbrev

      t.timestamps
    end
  end
end
