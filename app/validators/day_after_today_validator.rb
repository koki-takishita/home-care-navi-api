class DayAfterTodayValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present? && value > Time.zone.today

    record.errors.add(attribute, 'は、今日以前の日付を入力してください')
  end
end