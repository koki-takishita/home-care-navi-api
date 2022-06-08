class Office < ApplicationRecord
  include FlagShihTzu
  belongs_to :user
  has_many :staff
  has_many :care_recipient

  has_flags(
    1 => :sunday,
    2 => :monday,
    3 => :tuesday,
    4 => :wednesday,
    5 => :thursday,
    6 => :friday,
    7 => :saturday
  )

end