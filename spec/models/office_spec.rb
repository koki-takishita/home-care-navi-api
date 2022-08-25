require 'rails_helper'

RSpec.describe 'Officeモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it '1:1となっている' do
        expect(Office.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Appointmentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Office.reflect_on_association(:appointments).macro).to eq :has_many
      end
    end

    context 'Staffモデルとの関係' do
      it '1:Nとなっている' do
        expect(Office.reflect_on_association(:staffs).macro).to eq :has_many
      end
    end

    context 'CareRecipientモデルとの関係' do
      it '1:Nとなっている' do
        expect(Office.reflect_on_association(:care_recipients).macro).to eq :has_many
      end
    end

    context 'Thankモデルとの関係' do
      it '1:Nとなっている' do
        expect(Office.reflect_on_association(:thanks).macro).to eq :has_many
      end
    end

    context 'OfficeDetailモデルとの関係' do
      it '1:1となっている' do
        expect(Office.reflect_on_association(:office_detail).macro).to eq :has_one
      end
    end

    context 'Bookmarkモデルとの関係' do
      it '1:Nとなっている' do
        expect(Office.reflect_on_association(:bookmarks).macro).to eq :has_many
      end
    end

    context 'Historyモデルとの関係' do
      it '1:Nとなっている' do
        expect(Office.reflect_on_association(:histories).macro).to eq :has_many
      end
    end
  end

  describe 'バリデーションのテスト' do
    before do
      @office = build(:office)
    end

    it 'すべての項目の値が正しい場合、有効である' do
      expect(@office).to be_valid
    end

    it '事業所名がない場合、無効である' do
      @office = build(:office, name: nil)
      @office.valid?
      expect(@office.errors[:name]).to include('を入力してください')
    end

    it '事業所名が31文字以上の場合、無効である' do
      invalid_name = 'a' * 31
      @office = build(:office, name: invalid_name)
      @office.valid?
      expect(@office.errors[:name]).to include('は30文字以内で入力してください')
    end

    it '特徴タイトルがない場合、無効である' do
      @office = build(:office, title: nil)
      @office.valid?
      expect(@office.errors[:title]).to include('を入力してください')
    end

    it '特徴タイトルが51文字以上の場合、無効である' do
      invalid_title = 'a' * 51
      @office = build(:office, title: invalid_title)
      @office.valid?
      expect(@office.errors[:title]).to include('は50文字以内で入力してください')
    end

    it '休日がない場合、無効である' do
      @office = build(:office, flags: nil)
      @office.valid?
      # errors[:flags]が反映されないので、連動しているselected_flagsのエラーメッセージを表示させる
      expect(@office.errors[:selected_flags]).to include('を入力してください')
    end

    it '営業日に関する説明がない場合、無効である' do
      @office = build(:office, business_day_detail: nil)
      @office.valid?
      expect(@office.errors[:business_day_detail]).to include('を入力してください')
    end

    it '営業日に関する説明が121文字以上の場合、無効である' do
      invalid_business_day_detail = 'a' * 121
      @office = build(:office, business_day_detail: invalid_business_day_detail)
      @office.valid?
      expect(@office.errors[:business_day_detail]).to include('は120文字以内で入力してください')
    end

    it '電話番号がない場合、無効である' do
      @office = build(:office, phone_number: nil)
      @office.valid?
      expect(@office.errors[:phone_number]).to include('を入力してください')
    end

    it '電話番号のフォーマットが適切でない場合、無効である' do
      # [ハイフンなし、{2~4桁}-{2~4桁}~{4桁}以外]
      invalid_phone_numbers = %w[09012345678 1-234-5678 123-45678-901 123-456-78901]
      invalid_phone_numbers.each do |invalid_phone_number|
        @office = build(:office, phone_number: invalid_phone_number)
        @office.valid?
        expect(@office.errors[:phone_number]).to include('は不正な値です')
      end
    end

    it '電話番号が重複している場合、無効である' do
      phone_number = '111-1111-1111'
      create(:office, phone_number: phone_number)
      @office = build(:office, phone_number: phone_number)
      @office.valid?
      expect(@office.errors[:phone_number]).to include('はすでに存在します')
    end

    it 'FAX番号のフォーマットが適切でない場合、無効である' do
      # [ハイフンなし、{2~4桁}-{2~4桁}~{4桁}以外]
      invalid_fax_numbers = %w[09012345678 1-234-5678 123-45678-901 123-456-78901]
      invalid_fax_numbers.each do |invalid_fax_number|
        @office = build(:office, fax_number: invalid_fax_number)
        @office.valid?
        expect(@office.errors[:fax_number]).to include('は不正な値です')
      end
    end

    it '住所がない場合、無効である' do
      @office = build(:office, address: nil)
      @office.valid?
      expect(@office.errors[:address]).to include('を入力してください')
    end

    it '画像が6枚以上ある場合、無効である' do
      invalid_images = [Rack::Test::UploadedFile.new('spec/fixtures/island.png', 'image/png')] * 6
      @office = build(:office, images: invalid_images)
      @office.valid?
      expect(@office.errors[:images]).to include('は5枚以下でアップロードしてください')
    end

    it '画像のファイルサイズが11MB以上ある場合、無効である' do
      invalid_image = [Rack::Test::UploadedFile.new('spec/fixtures/sample_png_image_20mb.png', 'image/png')]
      @office = build(:office, images: invalid_image)
      @office.valid?
      expect(@office.errors[:images]).to include('サイズは10MB以下でアップロードしてください')
    end

    it '画像の拡張子が適切でない場合、無効である' do
      invalid_image = [Rack::Test::UploadedFile.new('spec/fixtures/sample-svg_image.svg', 'image/svg+xml')]
      @office = build(:office, images: invalid_image)
      @office.valid?
      expect(@office.errors[:images]).to include('は「.gif」または「.png」「.jpeg」「.jpg」の画像を指定してください')
    end
  end
end
