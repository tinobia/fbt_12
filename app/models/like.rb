class Like < ApplicationRecord
  belongs_to :user
  belongs_to :review

  scope :of_user, ->(user){where user: user}
end
