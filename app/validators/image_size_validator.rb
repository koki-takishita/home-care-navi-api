class ImageSizeValidator < ActiveModel::EachValidator
  MAXIMUM_SIZE = 10.megabytes # => 10485760

  def validate_each(record, attribute, value)
    return unless value.attached?

    value.each do |image|
      if image.byte_size > MAXIMUM_SIZE
        record.errors.add(attribute, 'サイズは10MB以下でアップロードしてください')
      end
    end
  end
end
