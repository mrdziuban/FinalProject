class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :topic_id
      t.integer :user_id
      t.text :text
      t.integer :parent_comment_id

      t.timestamps
    end

    add_index :comments, [:topic_id, :user_id, :parent_comment_id]
  end
end
