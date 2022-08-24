class CareRecipient < ApplicationRecord
  with_options presence: true do
    validates :kana
    validates :name, length: { maximum: 30 }
    validates :family, length: { maximum: 30 }
    validates :address
  end

  belongs_to :office
  belongs_to :staff
  has_one_attached :image

  def image_url
    helpers = Rails.application.routes.url_helpers
    if image.blank?
      nil
    else
      helpers.url_for(image)
    end
  end
end
