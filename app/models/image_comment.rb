class ImageComment < ApplicationRecord
    include Rails.application.routes.url_helpers
    belongs_to :office_detail
    has_one_attached :image
end

  def image_url
    helpers = Rails.application.routes.url_helpers
    if image.blank?
      return
    else
      helpers.url_for(image)
  end
end
