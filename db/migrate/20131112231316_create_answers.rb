class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :micropost_id
      t.string :text

      t.timestamps
    end

    add_index :answers, :micropost_id
  end
end
