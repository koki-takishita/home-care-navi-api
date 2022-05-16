class Office < ApplicationRecord
  include FlagShihTzu
  belongs_to :user

  has_flags(
    1 => :sunday,
    2 => :monday,
    3 => :tuesday,
    4 => :wednesday,
    5 => :thursday,
    6 => :fridayr,
    7 => :saturday
  )

end