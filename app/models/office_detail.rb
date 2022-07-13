class OfficeDetail < ApplicationRecord
  belongs_to :office,dependent: :destroy
  has_one :image_comment, dependent: :destroy
  validates :detail, :service_type, presence: true
end
