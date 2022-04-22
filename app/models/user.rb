class User < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }
  has_secure_password
  validates :password, presence: true, length: { in: 8..32 }
  VALID_PHONE_REGEX = /\A\d{10,11}\z/
  validates :phone_number, presence: true,
            format: { with: VALID_PHONE_REGEX }
  VALID_POST_REGEX = /\A\d{7}\z/
  validates :post_code, presence: true,
  format: { with: VALID_POST_REGEX }
  validates :address, presence: true
  enum user_type:    { customer: 1, specialist: 2 }
end
