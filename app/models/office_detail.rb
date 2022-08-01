class OfficeDetail < ApplicationRecord
  belongs_to :office
  has_many_attached :images
  validates :detail, :service_type, presence: true

  def image_url
    helpers = Rails.application.routes.url_helpers
    if images.blank?
      return
    else
      images.map{|image| helpers.url_for(image) }
    end
  end
end
