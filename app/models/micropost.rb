require 'will_paginate/array'

class Micropost < ActiveRecord::Base
  belongs_to :user

  has_many :mentions, foreign_key: :post_id, dependent: :destroy
  has_many :mentioned_users, through: :mentions, source: :user

  default_scope -> { order('microposts.created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence:true, length: { maximum: 140 }

  after_save :extract_mentions

  scope :quiet, -> { where(quiet: true) }
  scope :loud, -> { where(quiet: false) }
  scope :mentions_user, lambda { |user|
    joins(:mentions).where(mentions: { user_id: user.id })
  }

  scope :visible_to_user, lambda { |user|
    (loud | mentions_user(user) | where(user_id: user.id)).sort_by { |post| post[:created_at] }.reverse
  }

  def self.from_users_followed_by(user)
  	followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    where("microposts.user_id = :user_id OR microposts.user_id IN (#{followed_user_ids})", user_id: user.id).visible_to_user(user)
  end

  private

    def extract_mentions
      regex = /@([a-zA-Z0-9_]+)/
      content = self.content
      q = self.quiet

      match_data = regex.match(content)
      if match_data
        while match_data
          username = match_data[1]
          mentioned_user = User.find_by_username(username)
          if mentioned_user
            self.mentions.create(user: mentioned_user)
            content = match_data.post_match
            q ||= true
          end

          match_data = regex.match(content)
        end

        self.update_attributes(content: content.strip, quiet: q)
      end
    end
end
