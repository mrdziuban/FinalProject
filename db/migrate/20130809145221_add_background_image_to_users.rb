class AddBackgroundImageToUsers < ActiveRecord::Migration
  def change
    add_attachment :users, :profile_background
  end
end
