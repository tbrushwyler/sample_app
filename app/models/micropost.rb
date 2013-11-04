class Micropost < ActiveRecord::Base
  belongs_to :user

  has_many :mentions, foreign_key: :post_id, dependent: :destroy
  has_many :mentioned_users, through: :mentions, source: :user

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence:true, length: { maximum: 140 }

  after_save :extract_mentions

  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    mentioned_user_ids = "SELECT user_id FROM mentions WHERE post_id = id"
    count_of_mentioned_users = "SELECT COUNT(*) FROM mentions WHERE post_id = id"
    where("user_id = :user_id OR (user_id IN (#{followed_user_ids}) AND (:user_id IN (#{mentioned_user_ids}) OR (#{count_of_mentioned_users}) = 0))", user_id: user.id)
  	# where("user_id IN (#{followed_user_ids}) OR user_id = :user_id OR :user_id = in_reply_to_user_id", user_id: user.id)
  end

  private

    def extract_mentions
      regex = /@([a-zA-Z0-9_]+)/
      content = self.content

      match_data = regex.match(content)
      if match_data
        while match_data
          username = match_data[1]
          mentioned_user = User.find_by_username(username)
          if mentioned_user
            self.mentions.create(user: mentioned_user)
            content = match_data.post_match
          end

          match_data = regex.match(content)
        end

        self.update_attributes(content: content)
      end
    end
end
