class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User
  validates :name, :phone_number, :post_code, :address, :email, presence: true
  validates :email, uniqueness: true
end
