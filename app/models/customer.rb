class Customer < User
  has_many :appointments, dependent: :destroy
  has_one :office, foreign_key: 'user_id', dependent: :destroy
  has_many :thanks, dependent: :destroy

  enum user_type: { customer: 0 }

  default_scope { where(user_type: :customer) }

end
