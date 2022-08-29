class OfficeDetail < ApplicationRecord
  belongs_to :office
  has_many_attached :images

  with_options presence: true do
    validates :detail, length: { maximum: 50 }
    validates :service_type
  end

  with_options length: { maximum: 50 } do
    validates :requirement
    validates :facility
    validates :management
  end

  with_options image_and_comment_interlock: true do
    validates :comment_1
    validates :comment_2
  end

  with_options allow_blank: true do
    validates :rooms, numericality: { in: 0..100, min: 0, max: 100 }
    validates :link,  format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  end

  validates :open_date, day_after_today: true
  validates :images,    image_size: true,
                        image_content_type: true

  def image_url
    helpers = Rails.application.routes.url_helpers
    return unless images.attached?

    images.map { |image| helpers.url_for(image) }
  end
end
