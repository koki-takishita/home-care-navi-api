class Appointment < ApplicationRecord
  has_one :office
  has_one :user

  validates :user_id, uniqueness: true
  
  enum called_status: { need_call: 0, called: 1, cancel: 2 }
end
