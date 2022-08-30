require 'rails_helper'

RSpec.describe 'Thankモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Thank.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Officeモデルとの関係' do
      it 'N:1となっている' do
        expect(Thank.reflect_on_association(:office).macro).to eq :belongs_to
      end
    end

    context 'Staffモデルとの関係' do
      it 'N:1となっている' do
        expect(Thank.reflect_on_association(:staff).macro).to eq :belongs_to
      end
    end
  end

  describe 'バリデーションのテスト' do
    before do
      @thank = build(:thank)
      @created_thank = create(:thank)
    end

    it 'すべての項目の値が正しい場合、有効である' do
      expect(@thank).to be_valid
    end

    it '利用者名がない場合、無効である' do
      @thank = build(:thank, name: nil)
      @thank.valid?
      expect(@thank.errors[:name]).to include('利用者名を入力してください')
    end

    it '利用者名が31文字以上の場合、無効である' do
      invalid_name = 'a' * 31
      @thank = build(:thank, name: invalid_name)
      @thank.valid?
      expect(@thank.errors[:name]).to include('は30文字以内で入力してください')
    end

    it '年齢がない場合、無効である' do
      @thank = build(:thank, age: nil)
      @thank.valid?
      expect(@thank.errors[:age]).to include('年齢を入力してください')
    end

    it 'お礼コメントがない場合、無効である' do
      @thank = build(:thank, comments: nil)
      @thank.valid?
      expect(@thank.errors[:comments]).to include('お礼コメントを入力してください')
    end

    it 'お礼コメントが121文字以上ある場合、無効である' do
      invalid_comment = 'a' * 121
      @thank = build(:thank, comments: invalid_comment)
      @thank.valid?
      expect(@thank.errors[:comments]).to include('は120文字以内で入力してください')
    end

    it '同じスタッフにお礼をした場合、無効である' do
      @thank = build(:thank,
                     user_id: @created_thank.user_id,
                     office_id: @created_thank.office_id,
                     staff_id: @created_thank.staff_id)
      @thank.valid?
      expect(@thank.errors[:staff_id]).to include('同じスタッフにお礼を作成できるのは1回までです')
    end
  end
end
