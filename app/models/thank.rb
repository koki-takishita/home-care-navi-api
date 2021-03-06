class Thank < ApplicationRecord
  belongs_to :user
  belongs_to :office
  belongs_to :staff
  validates :comments, presence: true, length: { maximum: 120 }
  validates :office_id, uniqueness: {
    scope: [ :user_id, :staff_id ],
      message: "に2回以上お礼は作成できません。"
    }
  scope :thank_list_of_office, ->(office_id) { eager_load(:staff, :office).where(office_id: office_id).order("thanks.updated_at DESC") }
end
