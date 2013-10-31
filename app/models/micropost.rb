class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :in_reply_to_user, class_name: "User"

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence:true, length: { maximum: 140 }

  @regex = /\A^@([a-zA-Z](_?[a-zA-Z0-9]+)*_?|_([a-zA-Z0-9]+_?)*)?\s?(.*)$\z/i

  def self.new(params = {})
  	new_post = super
  	match_data = @regex.match(new_post.content)

  	if match_data && match_data[1] && match_data[4]
	  to_user = User.find_by_username(match_data[1])
	  if to_user
	  	new_post.in_reply_to_user = to_user
	  	new_post.content = match_data[4]
	  end
  	end

  	new_post
  end

  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("user_id = :user_id OR (user_id IN (#{followed_user_ids}) AND in_reply_to_user_id IS NULL) OR in_reply_to_user_id = :user_id", user_id: user.id)
  	# where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR :user_id = in_reply_to_user_id", user_id: user.id)
  end
end
