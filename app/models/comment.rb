class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :content, presence: true

  scope :order_by_created_at, ->{order(created_at: :desc)}

  delegate :avatar, to: :user, prefix: true
  delegate :username, to: :user

  def comment_count
    comments.size
  end
end
