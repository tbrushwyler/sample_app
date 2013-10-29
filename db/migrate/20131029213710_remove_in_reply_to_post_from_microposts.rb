class RemoveInReplyToPostFromMicroposts < ActiveRecord::Migration
  def change
  	remove_column :microposts, :in_reply_to_post_id
  end
end
