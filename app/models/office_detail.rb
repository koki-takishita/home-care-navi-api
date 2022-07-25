class OfficeDetail < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :office
  has_many_attached :images
  validates :detail, :service_type, presence: true
end

  def images_url
    helpers = Rails.application.routes.url_helpers
    if images.blank?
      return
    else
      helpers.url_for(image)
  end
end
