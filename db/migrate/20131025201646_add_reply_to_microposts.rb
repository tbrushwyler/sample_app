class AddReplyToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :in_reply_to_user, :integer
    add_column :microposts, :in_reply_to_post, :integer
  end
end
