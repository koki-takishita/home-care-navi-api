class OfficeDetail < ApplicationRecord
  belongs_to :office, foreign_key: 'office_id',
  dependent: :destroy
  validates :office_id, uniqueness: true
  validates :detail, :service_type, presence: true
end
