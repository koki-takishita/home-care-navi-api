require 'rails_helper'

RSpec.describe CareRecipient, type: :model do
  describe 'アソシエーションのテスト' do
    context 'Officeモデルとの関係' do
      it 'N:1となっている' do
        expect(CareRecipient.reflect_on_association(:office).macro).to eq :belongs_to
      end
    end

    context 'Staffモデルとの関係' do
      it 'N:1となっている' do
        expect(CareRecipient.reflect_on_association(:staff).macro).to eq :belongs_to
      end
    end
  end

  describe 'バリデーションのテスト' do
    it '事業所id、名前、ふりがな、紹介文がある場合、有効である' do
      care_recipient = build(:care_recipient)
      expect(care_recipient).to be_valid
    end

    it '事業所idがない場合、無効である' do
      care_recipient = build(:care_recipient, office_id: nil)
      care_recipient.valid?
      expect(care_recipient.errors[:office]).to include('を入力してください')
    end

    it '名前がない場合、無効である' do
      care_recipient = build(:care_recipient, name: nil)
      care_recipient.valid?
      expect(care_recipient.errors[:name]).to include('を入力してください')
    end

    it '名前が31文字以上の場合、無効である' do
      invalid_name = 'a' * 31
      care_recipient = build(:care_recipient, name: invalid_name)
      care_recipient.valid?
      expect(care_recipient.errors[:name]).to include('は30文字以内で入力してください')
    end

    it 'ふりがながない場合、無効である' do
      care_recipient = build(:care_recipient, kana: nil)
      care_recipient.valid?
      expect(care_recipient.errors[:kana]).to include('を入力してください')
    end

    it 'ふりがながひらがな以外の場合、無効である' do
      invalid_kana = ['abc', 123, '$%&@!']
      care_recipient = build(:care_recipient, kana: invalid_kana.first)
      care_recipient.valid?
      expect(care_recipient.errors[:kana]).to include('は不正な値です')
      care_recipient = build(:care_recipient, kana: invalid_kana.second)
      care_recipient.valid?
      expect(care_recipient.errors[:kana]).to include('は不正な値です')
      care_recipient = build(:care_recipient, kana: invalid_kana.third)
      care_recipient.valid?
      expect(care_recipient.errors[:kana]).to include('は不正な値です')
    end

    it 'ふりがなが31文字以上の場合、無効である' do
      invalid_kana = 'あ' * 31
      care_recipient = build(:care_recipient, kana: invalid_kana)
      care_recipient.valid?
      expect(care_recipient.errors[:kana]).to include('は30文字以内で入力してください')
    end

    it '年齢がない場合は無効である' do
      care_recipient = build(:care_recipient, age: nil)
      care_recipient.valid?
      expect(care_recipient.errors[:age]).to include('を入力してください')
    end

    it '郵便番号がない場合は無効である' do
      care_recipient = build(:care_recipient, post_code: nil)
      care_recipient.valid?
      expect(care_recipient.errors[:post_code]).to include('を入力してください')
    end

    it '郵便番号のフォーマットが適切でない場合、無効である' do
      invalid_post_codes = %w[1234567 12-3456 123-456]
      invalid_post_codes.each do |invalid_post_code|
        care_recipient = build(:user, post_code: invalid_post_code)
        care_recipient.valid?
        expect(care_recipient.errors[:post_code]).to include('は不正な値です')
      end
    end

    it '住所がない場合は無効である' do
      care_recipient = build(:care_recipient, address: nil)
      care_recipient.valid?
      expect(care_recipient.errors[:address]).to include('を入力してください')
    end

    it '家族情報が31文字以上の場合、無効である' do
      invalid_family = 'a' * 31
      care_recipient = build(:care_recipient, family: invalid_family)
      care_recipient.valid?
      expect(care_recipient.errors[:family]).to include('は30文字以内で入力してください')
    end

    it 'スタッフidがない場合、無効である' do
      care_recipient = build(:care_recipient, staff_id: nil)
      care_recipient.valid?
      expect(care_recipient.errors[:staff]).to include('を入力してください')
    end
  end
end
