class Appointment < ApplicationRecord
  belongs_to :office
  belongs_to :user

  # 共通のバリデーションをまとめる
  with_options presence: true do
    validates :meet_date
    validates :meet_time
    validates :name, length: { maximum: 30 }
    validates :age
    validates :phone_number, format: { with: /\A\d{2,4}-\d{2,4}-\d{4}\z/ }
    validates :comment
    validates :called_status
  end

  validate :day_before_today

  def day_before_today
    return unless meet_date.present? && (meet_date <= Time.zone.today)

    errors.add(:meet_date, 'は、明日以降の日付を入力してください')
  end

  enum called_status: { need_call: 0, called: 1, cancel: 2 }
end
