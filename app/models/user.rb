class User < ApplicationRecord
  ATTRIBUTES = %i(name email password password_confirmation).freeze

  before_save :downcase_email

  validates :email, presence: true,
                    length: {minimum: Settings.user.min_len_email,
                             maximum: Settings.user.max_len_email},
                    format: {with: Regexp.new(Settings.user.VALID_EMAIL_REGEX)},
                    uniqueness: {case_sensitive: false}

  validates :name, presence: true, length: {maximum: Settings.user.max_len_name}

  validates :password, presence: true,
                       length: {minimum: Settings.user.min_len_password},
                       if: :password

  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost:)
  end

  private
  def downcase_email
    email.downcase!
  end
end
