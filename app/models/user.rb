class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  attr_accessor :activation_token, :remember_token, :reset_token

  validates :email, format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.max_email_length}, presence: true,
    uniqueness: {case_sensitive: false}
  validates :username, presence: true,
    length: {maximum: Settings.max_username_length,
             minimum: Settings.min_username_length},
    uniqueness: true
  validates :password, length: {minimum: Settings.min_password_length},
    presence: true, allow_nil: true
  validates :first_name, length: {maximum: Settings.max_first_name_length}
  validates :last_name, length: {maximum: Settings.max_last_name_length}

  before_create :create_activation_digest
  before_save ->{email.downcase!}

  has_secure_password

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def activate
    update_attributes activated: true, activated_at: Time.zone.now
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password? token
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def forget
    update_attributes remember_digest: nil
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.reset_expired.hours.ago
  end

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST
        else
          BCrypt::Engine.cost
        end

      BCrypt::Password.create string, cost: cost
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
