class Thank < ApplicationRecord
  belongs_to :user
  belongs_to :office
  belongs_to :staff
  validates :comments, presence: true, length: { maximum: 120 }
end
