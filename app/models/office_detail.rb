class OfficeDetail < ApplicationRecord
  belongs_to :office, foreign_key: 'office_id',
  inverse_of: :office_detail,  dependent: :destroy
end
