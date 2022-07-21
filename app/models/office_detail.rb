class OfficeDetail < ApplicationRecord
  belongs_to :office
  has_many :image_comments, dependent: :destroy
  validates :detail, :service_type, presence: true


=begin
  validate :check_number_image_comment
  def check_number_image_comment
    errors.add(:image_comment, "登録できる数は２つまで") if image_comment.count > 2
  end
=end
end
