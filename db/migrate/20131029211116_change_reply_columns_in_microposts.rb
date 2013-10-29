class ChangeReplyColumnsInMicroposts < ActiveRecord::Migration
  def change
  	rename_column :microposts, :in_reply_to_user, :in_reply_to_user_id
  	rename_column :microposts, :in_reply_to_post, :in_reply_to_post_id
  end
end
