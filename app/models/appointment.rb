class Appointment < ApplicationRecord
  belongs_to :office
  belongs_to :user

  enum called_status: { need_call: 0, called: 1, cancel: 2 }
end
