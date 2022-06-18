class CareRecipient < ApplicationRecord
  belongs_to :office
  belongs_to :staff
  has_one_attached :image
  def image_url
    helpers = Rails.application.routes.url_helpers
    if image.blank?
      return
    else
      helpers.url_for(image)
    end
end
end
