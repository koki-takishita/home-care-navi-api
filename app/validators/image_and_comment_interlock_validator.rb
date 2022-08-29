class ImageAndCommentInterlockValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    case attribute
    when :comment_1
      image = record.images.first
      image_number = 1
      check_interlock(record, attribute, value, image, image_number)
    when :comment_2
      case record.images.count
      when 1
        image = record.images.first
      when 2
        image = record.images.second
      end
      image_number = 2
      check_interlock(record, attribute, value, image, image_number)
    end
  end

  private

    def check_interlock(record, attribute, comment, image, number)
      # 画像があって、画像のコメントが空の場合
      if image.present? && comment.blank?
        record.errors.add(:images, "#{number}を登録する場合は、特徴画像#{number}の説明を入力してください")
      # 画像が空で、画像のコメントがある場合
      elsif image.blank? && comment.present?
        record.errors.add(attribute, "を登録する場合は、特徴画像#{number}をアップロードしてください")
      end
    end
end
