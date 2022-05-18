class Staff < ApplicationRecord
  has_many :office
  has_one_attached :image
end
