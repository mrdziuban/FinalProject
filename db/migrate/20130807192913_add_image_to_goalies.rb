class AddImageToGoalies < ActiveRecord::Migration
  def change
    add_attachment :goalies, :image
  end
end
