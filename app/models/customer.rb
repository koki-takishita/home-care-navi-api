class Customer < User
  has_many :appointments, dependent: :destroy
  has_one :office, foreign_key: 'user_id', dependent: :destroy
  has_many :thanks, dependent: :destroy

  enum user_type: { customer: 0 }

  def self.default_scope
    where(user_type: 0)
  end

end
