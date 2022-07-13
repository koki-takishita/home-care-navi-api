class ImageComment < ApplicationRecord
    belongs_to :office_detail, dependent: :destroy
    has_many_attached :images
  end

  def image_url
    helpers = Rails.application.routes.url_helpers
    if images.blank?
      return
    else
      images.map{|image| helpers.url_for(image) }
    end
end
