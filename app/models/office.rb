class Office < ApplicationRecord
  include FlagShihTzu
  # TODO 存在しないuser_idが入力されたらバリテーションで引っかかるようにしたい
  belongs_to :user, foreign_key: 'user_id', class_name: 'Specialist', optional: true
  has_many :appointments, dependent: :destroy
  has_many :staffs, dependent: :destroy
  has_many :care_recipients, dependent: :destroy
  has_many :thanks, dependent: :destroy
  has_one  :office_detail, dependent: :destroy
  has_many_attached :images
  validates :user_id, uniqueness: true, allow_nil: true

  before_create do
    self.post_code = post_code.delete('-')
  end

  after_find do |office|
    purse_post_code = office.post_code
    purse_post_code[3, 0] = '-'
    office.post_code = purse_post_code
  end

  def image_url
    helpers = Rails.application.routes.url_helpers
    if images.blank?
      return
    else
      images.map{|image| helpers.url_for(image) }
    end
  end

  has_flags(
    1 => :sunday,
    2 => :monday,
    3 => :tuesday,
    4 => :wednesday,
    5 => :thursday,
    6 => :friday,
    7 => :saturday
  )

end
