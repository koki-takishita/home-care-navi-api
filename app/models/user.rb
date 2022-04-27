class User < ApplicationRecord
  include TokenGenerateService
  before_validation :downcase_email
  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true
  validates :post_code, presence: true
  validates :password, presence: true, allow_nil: true
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

  # リフレッシュトークンのJWT IDを記憶
  def remember(jti)
    update!(refresh_jti: jti)
  end

  # リフレッシュトークンのJWT IDを削除
  def forget
    update!(refresh_jti: nil)
  end

  def response_json(payload = {})
    as_json(only: %i[id name]).merge(payload).with_indifferent_access
  end

  private

    def downcase_email
      email&.downcase!
    end
end
