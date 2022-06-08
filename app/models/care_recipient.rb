class CareRecipient < ApplicationRecord
  has_many :office
  has_many :staffs
  has_one_attached :image
end
