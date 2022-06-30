class OfficeDetail < ApplicationRecord
  belongs_to :office, foreign_key: 'office_id',
  dependent: :destroy
end
