class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.max_email_length}, presence: true,
    uniqueness: {case_sensitive: false}
  validates :username, presence: true,
    length: {maximum: Settings.max_username_length,
             minimum: Settings.min_username_length},
    uniqueness: true
  validates :first_name, length: {maximum: Settings.max_first_name_length}
  validates :last_name, length: {maximum: Settings.max_last_name_length}

  before_save ->{email.downcase!}
end
