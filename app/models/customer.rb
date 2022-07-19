class Customer < User
  has_many :appointments, dependent: :destroy
  has_many :thanks, foreign_key: 'user_id', dependent: :destroy
  enum user_type: { customer: 0 }
  default_scope { where(user_type: :customer) }
end
