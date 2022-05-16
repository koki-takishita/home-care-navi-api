class User < ApplicationRecord

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :confirmable

  include DeviseTokenAuth::Concerns::User

  enum user_type: { customer: 0, specialist: 1 }

  validates :name, :phone_number, :post_code, :address, :email, presence: true
  validates :phone_number, uniqueness: true

  def set_user_type(type)
    set_specialist if type == :specialist
  end

  private

  def set_specialist
    self.specialist!
  end

end
