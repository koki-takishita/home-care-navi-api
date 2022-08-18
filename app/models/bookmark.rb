class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :office

  scope :search_office_bookmark, ->(office_id, customer_id) { eager_load(:office, :user).where(office_id: office_id, user_id: customer_id) }
end
