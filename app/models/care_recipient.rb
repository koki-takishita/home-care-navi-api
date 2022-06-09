class CareRecipient < ApplicationRecord
  belongs_to :office
  belongs_to :staff
  has_one_attached :image
end
