class Staff < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :office
  has_one_attached :image

  def image_url
      helpers = Rails.application.routes.url_helpers
      helpers.url_for(image)
  end
end