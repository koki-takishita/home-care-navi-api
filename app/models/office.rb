class Office < ApplicationRecord
  include FlagShihTzu
  # TODO: 存在しないuser_idが入力されたらバリテーションで引っかかるようにしたい
  belongs_to :user, class_name: 'Specialist', optional: true
  has_many :appointments, dependent: :destroy
  has_many :staffs, dependent: :destroy
  has_many :care_recipients, dependent: :destroy
  has_many :thanks, dependent: :destroy
  has_one  :office_detail, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :histories, dependent: :destroy
  has_many_attached :images
  validates :user_id, :phone_number, :fax_number, uniqueness: true, allow_blank: true

  scope :phone_number_exist?, ->(phone_number) { where(phone_number: phone_number) }

  before_create do
    self.post_code = post_code.delete('-')
    self.fax_number = nil if fax_number.blank?
  end

  after_find do |office|
    purse_post_code = office.post_code
    purse_post_code[3, 0] = '-'
    office.post_code = purse_post_code
  end

  def image_url
    helpers = Rails.application.routes.url_helpers
    # 画像がなければreturn
    return unless images.attached?

    images.map { |image| helpers.url_for(image) }
  end

  def first_image_url
    if images.attached?
      image_url.first
    else
      []
    end
  end

  def staff_count
    staffs.count
  end

  def latest_thank_comment
    if thanks.exists?
      thanks.last.comments
    else
      'お礼の投稿はまだありません'
    end
  end

  def detail
    if office_detail.present?
      office_detail.detail.presence || '詳細情報は登録されていません'
    else
      '詳細情報は登録されていません'
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
