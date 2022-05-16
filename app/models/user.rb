class User < ApplicationRecord

  enum user_type: { customer: 0, specialist: 1 }
            # Include default devise modules.

  # Include default devise modules.

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable
  include DeviseTokenAuth::Concerns::User

  def set_user_type(type)
    set_specialist if type == :specialist
  end

  def set_specialist
    self.specialist!
  end

  validates :name, :phone_number, :post_code, :address, :email, presence: true
  validates :phone_number, uniqueness: true

end
