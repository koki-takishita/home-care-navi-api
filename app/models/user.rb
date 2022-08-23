class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :confirmable
  include DeviseTokenAuth::Concerns::User

  attribute :redirect_url
  has_many :appointments, dependent: :destroy
  has_one :office, dependent: :destroy
  has_many :thanks, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :histories, dependent: :destroy

  enum user_type: { customer: 0, specialist: 1 }

  with_options presence: true do
    validates :name,         length: { maximum: 30 }
    validates :email,        uniqueness: true,
                             length: { maximum: 255 },
                             format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :password,     length: { maximum: 32, minimum: 8 },
                             format: { with: /\A[a-zA-Z0-9]+\z/ }
    validates :phone_number, uniqueness: true,
                             format: { with: /\A\d{2,4}-\d{2,4}-\d{4}\z/ }
    validates :post_code,    format: { with: /\A\d{3}[-]\d{4}\z/ }
    validates :address
  end

  scope :phone_number_exist?, ->(phone_number) { where(phone_number: phone_number) }
  # override devise method to include additional info as opts hash
  def send_confirmation_instructions(opts = {})
    generate_confirmation_token! unless @raw_confirmation_token

    # fall back to "default" config name
    opts[:client_config] ||= 'default'
    opts[:to] = unconfirmed_email if pending_reconfirmation?
    opts[:redirect_url] ||= DeviseTokenAuth.default_confirm_success_url || redirect_url

    send_devise_notification(:confirmation_instructions, @raw_confirmation_token, opts)
  end

end
