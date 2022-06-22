class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :confirmable
  include DeviseTokenAuth::Concerns::User
  default_scope { where(user_type: 0) }

  has_many :appointments, dependent: :destroy
  has_one :office, foreign_key: 'user_id', dependent: :destroy
  has_many :thanks, dependent: :destroy
  has_one :office, dependent: :destroy

  enum user_type: { customer: 0, specialist: 1 }

  validates :name, :phone_number, :post_code, :address, :email, presence: true
  validates :phone_number, uniqueness: true
end
