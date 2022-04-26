class User < ApplicationRecord
  include UserAuth::Tokenizable
  before_validation :downcase_email
  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :phone_number, presence: true, uniqueness: true
  validates :post_code, presence: true
  validates :address, presence: true
  validates :user_type, presence: true
  validates :activated, inclusion: { in: [true, false] }

  has_secure_password
  enum user_type: { customer: 0, specialist: 1 }

  class << self
    def find_activated(email)
      find_by(email: email, activated: true)
    end
  end

  def email_activated?
    users = User.where.not(id: id)
    users.find_activated(email).present?
  end

  def my_json
    as_json(only: %i[id name email created_at])
  end

  def downcase_email
    email&.downcase!
  end
end
