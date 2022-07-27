class OfficeDetail < ApplicationRecord
  belongs_to :office
  has_many_attached :image
  validates :detail, :service_type, presence: true

  def image_url
    helpers = Rails.application.routes.url_helpers
    if image.blank?
      return
    else
      helpers.url_for(image)
    end
  end
end
