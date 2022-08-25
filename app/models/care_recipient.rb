class CareRecipient < ApplicationRecord
  with_options presence: true do
    validates :kana,  presence: true,
                      format: { with: /\A[ぁ-んー－　 ]+\z/.freeze },
                      length: { maximum: 30 }
    validates :name, length: { maximum: 30 }
    validates :family, length: { maximum: 30 }
    validates :address
    validates :age
    validates :post_code, format: { with: /\A\d{3}-\d{4}\z/ }
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
