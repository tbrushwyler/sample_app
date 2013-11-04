class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.integer :user_id
      t.integer :post_id
      t.integer :index

      t.timestamps
    end

    add_index :mentions, :user_id
    add_index :mentions, :post_id
  end
end
