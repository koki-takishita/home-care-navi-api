class OfficeDetail < ApplicationRecord
  belongs_to :office, dependent: :destroy
end

