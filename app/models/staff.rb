class Staff < ApplicationRecord
  belongs_to :office
  has_many :care_recipients, dependent: :destroy
  has_one_attached :image
  has_many :thanks, dependent: :destroy

  validates :name,  presence: true,
                    length: { maximum: 30 }
  VALID_KANA_REGEX = /\A[ぁ-んー－　 ]+\z/.freeze
  validates :kana,  presence: true,
                    format: { with: VALID_KANA_REGEX },
                    length: { maximum: 30 }
  validates :introduction,  presence: true,
                            length: { maximum: 120 }

  def image_url
    helpers = Rails.application.routes.url_helpers
    if image.blank?
      nil
    else
      helpers.url_for(image)
    end
  end
end
