class RemoveInReplyToUserFromMicroposts < ActiveRecord::Migration
  def change
  	remove_column :microposts, :in_reply_to_user_id
  end
end
