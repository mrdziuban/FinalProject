class CreateAnalyses < ActiveRecord::Migration
  def change
    create_table :analyses do |t|
      t.string :title
      t.integer :user_id

      t.timestamps
    end

    add_attachment :analyses, :pdf
  end
end
