class User < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_one :office, foreign_key: 'user_id', dependent: :destroy
  
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :confirmable

  include DeviseTokenAuth::Concerns::User

  enum user_type: { customer: 0, specialist: 1 }

  validates :name, :phone_number, :post_code, :address, :email, presence: true
  validates :phone_number, uniqueness: true
  has_many :thanks, dependent: :destroy

  has_one :office, dependent: :destroy
end
