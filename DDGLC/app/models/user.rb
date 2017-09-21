class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :code, presence: true, uniqueness: { case_sensitive: false }, length: { is: 4 }
  validates :role, presence: true
  validates :password, presence: true, length: { in: 5..15 }, allow_nil: true


  has_secure_password
end
