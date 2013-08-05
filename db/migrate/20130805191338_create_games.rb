class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :date
      t.string :away
      t.string :home
      t.string :time
      t.string :result
      t.string :season

      t.timestamps
    end
  end
end
