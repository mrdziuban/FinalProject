class AddImageToPlayers < ActiveRecord::Migration
  def change
    add_attachment :players, :image
  end
end
