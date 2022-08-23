class Thank < ApplicationRecord
  belongs_to :user
  belongs_to :office
  belongs_to :staff
  validates :comments, presence: true, length: { maximum: 120 }
  validates :name, length: { maximum: 30 }
  validates :name, :age, presence: true
  validates :staff_id, uniqueness: { scope: %i[user_id office_id] }
  scope :thank_list_of_office, ->(office_id) { eager_load(:staff, :office).where(office_id: office_id).order('thanks.updated_at DESC') }
end
