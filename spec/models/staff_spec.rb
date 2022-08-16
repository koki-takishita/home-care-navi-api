require 'rails_helper'

RSpec.describe 'Staffモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Officeモデルとの関係' do
      it 'N:1となっている' do
        expect(Staff.reflect_on_association(:office).macro).to eq :belongs_to
      end
    end

    context 'CareRecipientモデルとの関係' do
      it '1:Nとなっている' do
        expect(Staff.reflect_on_association(:care_recipients).macro).to eq :has_many
      end
    end

    context 'Thankモデルとの関係' do
      it '1:Nとなっている' do
        expect(Staff.reflect_on_association(:thanks).macro).to eq :has_many
      end
    end
  end

  describe 'バリデーションのテスト' do
    it '事業所id、名前、ふりがな、紹介文がある場合、有効である' do
      staff = build(:staff)
      # staff.valid? が true ならテストは期待通りに動いてることになる
      expect(staff).to be_valid
    end

    it '事業所idがない場合、無効である' do
      staff = build(:staff, office_id: nil)
      staff.valid?
      expect(staff.errors[:office]).to include('を入力してください')
    end

    it '名前がない場合、無効である' do
      staff = build(:staff, name: nil)
      staff.valid?
      expect(staff.errors[:name]).to include('を入力してください')
    end

    it '名前が31文字以上の場合、無効である' do
      invalid_name = 'a' * 31
      staff = build(:staff, name: invalid_name)
      staff.valid?
      expect(staff.errors[:name]).to include('は30文字以内で入力してください')
    end

    it 'ふりがながない場合、無効である' do
      staff = build(:staff, kana: nil)
      staff.valid?
      expect(staff.errors[:kana]).to include('を入力してください')
    end

    it 'ふりがながひらがな以外の場合、無効である' do
      invalid_kana = ['abc', 123, '$%&@!']
      staff = build(:staff, kana: invalid_kana.first)
      staff.valid?
      expect(staff.errors[:kana]).to include('は不正な値です')
      staff = build(:staff, kana: invalid_kana.second)
      staff.valid?
      expect(staff.errors[:kana]).to include('は不正な値です')
      staff = build(:staff, kana: invalid_kana.third)
      staff.valid?
      expect(staff.errors[:kana]).to include('は不正な値です')
    end

    it 'ふりがなが31文字以上の場合、無効である' do
      invalid_kana = 'あ' * 31
      staff = build(:staff, kana: invalid_kana)
      staff.valid?
      expect(staff.errors[:kana]).to include('は30文字以内で入力してください')
    end

    it '紹介文がない場合、無効である' do
      staff = build(:staff, introduction: nil)
      staff.valid?
      expect(staff.errors[:introduction]).to include('を入力してください')
    end

    it '紹介文が121文字以上の場合、無効である' do
      invalid_introduction = 'a' * 121
      staff = build(:staff, introduction: invalid_introduction)
      staff.valid?
      expect(staff.errors[:introduction]).to include('は120文字以内で入力してください')
    end
  end
end
