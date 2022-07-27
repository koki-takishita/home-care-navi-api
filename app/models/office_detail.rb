class OfficeDetail < ApplicationRecord
  belongs_to :office,dependent: :destroy
  validates :detail, :service_type, presence: true
end
