class CareRecipient < ApplicationRecord
  has_many :offices
  has_many :staffs
  has_one_attached :image
end
