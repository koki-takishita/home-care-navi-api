require 'rails_helper'

RSpec.describe 'OfficeDetailモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Officeモデルとの関係' do
      it '1:1となっている' do
        expect(OfficeDetail.reflect_on_association(:office).macro).to eq :belongs_to
      end
    end
  end

  describe 'バリデーションのテスト' do
    before do
      @office_detail = build(:office)
    end

    it 'すべての項目の値が正しい場合、有効である' do
      expect(@office_detail).to be_valid
    end

    it '特徴タイトルの説明がない場合、無効である' do
      @office_detail = build(:office_detail, detail: nil)
      @office_detail.valid?
      expect(@office_detail.errors[:detail]).to include('を入力してください')
    end

    it '特徴タイトルの説明が51文字以上場合、無効である' do
      invalid_detail = 'a' * 51
      @office_detail = build(:office_detail, detail: invalid_detail)
      @office_detail.valid?
      expect(@office_detail.errors[:detail]).to include('は50文字以内で入力してください')
    end

    it '開設年月が明日以降の日付の場合、無効である' do
      @office_detail = build(:office_detail, open_date: Time.zone.tomorrow)
      @office_detail.valid?
      expect(@office_detail.errors[:open_date]).to include('は、今日以前の日付を入力してください')
    end

    it '居室数が数字以外の場合、無効である' do
      invalid_rooms = 'a'
      @office_detail = build(:office_detail, rooms: invalid_rooms)
      @office_detail.valid?
      expect(@office_detail.errors[:rooms]).to include('は数値で入力してください')
    end

    it '居室数が全角数字の場合、無効である' do
      invalid_rooms = '１'
      @office_detail = build(:office_detail, rooms: invalid_rooms)
      @office_detail.valid?
      expect(@office_detail.errors[:rooms]).to include('は数値で入力してください')
    end

    it '入居時の要件が51文字以上場合、無効である' do
      invalid_requirement = 'a' * 51
      @office_detail = build(:office_detail, requirement: invalid_requirement)
      @office_detail.valid?
      expect(@office_detail.errors[:requirement]).to include('は50文字以内で入力してください')
    end

    it '共用設備が51文字以上場合、無効である' do
      invalid_facility = 'a' * 51
      @office_detail = build(:office_detail, facility: invalid_facility)
      @office_detail.valid?
      expect(@office_detail.errors[:facility]).to include('は50文字以内で入力してください')
    end

    it '経営・事業主体が51文字以上場合、無効である' do
      invalid_management = 'a' * 51
      @office_detail = build(:office_detail, management: invalid_management)
      @office_detail.valid?
      expect(@office_detail.errors[:management]).to include('は50文字以内で入力してください')
    end

    it 'サイトURLのフォーマットが適切でない場合、無効である' do
      invalid_url = 'https://サイトURLです'
      @office_detail = build(:office_detail, link: invalid_url)
      @office_detail.valid?
      expect(@office_detail.errors[:link]).to include('は不正な値です')
    end

    it '特徴画像1の説明があるときに、特徴画像1がない場合、無効である' do
      @office_detail = build(:office_detail,
                             comment_2: nil,
                             images: nil)
      @office_detail.valid?
      expect(@office_detail.errors[:comment_1]).to include('を登録する場合は、特徴画像1をアップロードしてください')
    end

    it '特徴画像1があるときに、特徴画像1の説明がない場合、無効である' do
      image = [Rack::Test::UploadedFile.new('spec/fixtures/island.png')]
      @office_detail = build(:office_detail,
                             comment_1: nil,
                             comment_2: nil,
                             images: image)
      @office_detail.valid?
      expect(@office_detail.errors[:images]).to include('1を登録する場合は、特徴画像1の説明を入力してください')
    end

    it '特徴画像2の説明があるときに、特徴画像2がない場合、無効である' do
      @office_detail = build(:office_detail,
                             comment_1: nil,
                             images: nil)
      @office_detail.valid?
      expect(@office_detail.errors[:comment_2]).to include('を登録する場合は、特徴画像2をアップロードしてください')
    end

    it '特徴画像2があるときに、特徴画像2の説明がない場合、無効である' do
      image = [Rack::Test::UploadedFile.new('spec/fixtures/island.png')]
      @office_detail = build(:office_detail,
                             comment_2: nil,
                             images: image)
      @office_detail.valid?
      expect(@office_detail.errors[:images]).to include('2を登録する場合は、特徴画像2の説明を入力してください')
    end

    it '画像のファイルサイズが10MBを超える場合、無効である' do
      invalid_image = [Rack::Test::UploadedFile.new('spec/fixtures/island.png')]
      @office_detail = build(:office_detail, images: invalid_image)
      # 元のbyte_sizeは337842(340KB)
      @office_detail.images.first.byte_size = 10_485_761 # 10MB => 10485760
      @office_detail.valid?
      expect(@office_detail.errors[:images]).to include('サイズは10MB以下でアップロードしてください')
    end

    it '画像の拡張子が「.gif」または「.png」「.jpeg」「.jpg」でない場合、無効である' do
      invalid_image = [Rack::Test::UploadedFile.new('spec/fixtures/sample_svg_image.svg')]
      @office_detail = build(:office_detail, images: invalid_image)
      @office_detail.valid?
      expect(@office_detail.errors[:images]).to include('は「.gif」または「.png」「.jpeg」「.jpg」の画像を指定してください')
    end

    it '画像の拡張子が「.gif」または「.png」である場合、有効である' do
      valid_images = [
        Rack::Test::UploadedFile.new('spec/fixtures/sample_gif_image.gif'),
        Rack::Test::UploadedFile.new('spec/fixtures/island.png')
      ]
      @office_detail = build(:office_detail, images: valid_images)
      expect(@office_detail).to be_valid
    end

    it '画像の拡張子が「.jpeg」または「.jpg」である場合、有効である' do
      valid_images = [
        Rack::Test::UploadedFile.new('spec/fixtures/sample_jpeg_image.jpeg'),
        Rack::Test::UploadedFile.new('spec/fixtures/sample_jpg_image.jpg')
      ]
      @office_detail = build(:office_detail, images: valid_images)
      expect(@office_detail).to be_valid
    end
  end
end
