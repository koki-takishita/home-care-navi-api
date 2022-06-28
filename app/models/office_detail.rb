class OfficeDetail < ApplicationRecord
  belongs_to :office, dependent: :destroy
  inverse_of: :office_detail
/  has_many :image_comments,/
/  accepts_nested_attributes_for :image_comments /
end
