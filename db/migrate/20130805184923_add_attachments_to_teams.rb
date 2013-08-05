class AddAttachmentsToTeams < ActiveRecord::Migration
  def change
    add_attachment :teams, :background
    add_attachment :teams, :players_pic
  end
end
