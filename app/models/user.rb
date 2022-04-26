class User < ApplicationRecord
  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :phone_number, presence: true, uniqueness: true
  validates :post_code, presence: true
  validates :address, presence: true
  validates :user_type, presence: true

  has_secure_password
  enum user_type: { customer: 0, specialist: 1 }
end
