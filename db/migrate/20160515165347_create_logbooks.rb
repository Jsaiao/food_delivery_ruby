class CreateLogbooks < ActiveRecord::Migration
  def change
    create_table :logbooks do |t|
      t.integer :user_id
      t.string :action
      t.string :controller
      t.jsonb :options

      t.timestamps null: false
    end

    add_index :logbooks, :user_id
  end
end
