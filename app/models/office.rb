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

  scope :phone_number_exist?, ->(phone_number) { where(phone_number: phone_number) }

  before_create do
    self.post_code = post_code.delete('-')
    self.fax_number = nil if fax_number.blank?
  end

  with_options presence: true do
    validates :name,         length: { maximum: 30 }
    validates :title,        length: { maximum: 50 }
    validates :selected_flags
    validates :business_day_detail, length: { maximum: 120 }
    validates :phone_number, format: { with: /\A\d{2,4}-\d{2,4}-\d{4}\z/ }, uniqueness: true
    validates :address
  end

  with_options uniqueness: true do
    with_options allow_blank: true do
      validates :user_id
      validates :fax_number, format: { with: /\A\d{2,4}-\d{2,4}-\d{4}\z/ }
    end
  end

  validate :attached_file_number, :attached_file_size, :attached_file_content_type

  def attached_file_number
    return unless images.attached? && images.count >= 6

    errors.add(:images, 'は5枚以下でアップロードしてください')
  end

  def attached_file_size
    maximum_size = 10.megabytes # => 10485760
    return unless images.attached?

    images.each do |image|
      if image.byte_size > maximum_size
        errors.add(:images, 'サイズは10MB以下でアップロードしてください')
      end
    end
  end

  def attached_file_content_type
    extensions = ['image/png', 'image/jpeg', 'image/gif']
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(extensions)
        errors.add(:images, 'は「.gif」または「.png」「.jpeg」「.jpg」の画像を指定してください')
      end
    end
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
