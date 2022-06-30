class OfficeDetail < ApplicationRecord
  belongs_to :office, dependent: :destroy
  foreign_key: 'office_id'
end
