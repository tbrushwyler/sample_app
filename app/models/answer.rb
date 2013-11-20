class Answer < ActiveRecord::Base
  belongs_to :micropost

  # validates :micropost, presence: true
  validates :text, presence: true
end
