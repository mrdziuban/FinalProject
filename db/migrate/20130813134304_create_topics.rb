class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :title
      t.integer :user_id
      t.integer :forum_id

      t.timestamps
    end

    add_index :topics, :user_id
    add_index :topics, :forum_id
  end
end
