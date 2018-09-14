class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  before_save{email.downcase!}
  has_secure_password
  validates :name, presence: true,
                  length: {maximum: Settings.user.name.max_length}
  validates :email, presence: true,
                  length: {maximum: Settings.user.email.max_length},
                  format: {with: VALID_EMAIL_REGEX},
                  uniqueness: {case_sensitive: false}
  validates :password, presence: true,
                  length: {minimum: Settings.user.pass.min_length}
end
