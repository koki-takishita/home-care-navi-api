class ImageContentTypeValidator < ActiveModel::EachValidator
  EXTENSIONS = ['image/png', 'image/jpeg', 'image/gif'].freeze

  def validate_each(record, attribute, value)
    return unless value.attached?

    value.each do |image|
      unless image.content_type.in?(EXTENSIONS)
        record.errors.add(attribute, 'は「.gif」または「.png」「.jpeg」「.jpg」の画像を指定してください')
      end
    end
  end
end
