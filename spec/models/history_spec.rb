require 'rails_helper'

RSpec.describe 'Historyモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(History.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Officeモデルとの関係' do
      it 'N:1となっている' do
        expect(History.reflect_on_association(:office).macro).to eq :belongs_to
      end
    end
  end

  describe 'バリデーションのテスト' do
    it 'ユーザーidと事業所idがある場合、有効である' do
      history = build(:history)
      expect(history).to be_valid
    end

    it 'ユーザーidがない場合、無効である' do
      history = build(:history, user_id: nil)
      history.valid?
      expect(history.errors[:user]).to include('を入力してください')
    end

    it '事業所idがない場合、無効である' do
      history = build(:history, office_id: nil)
      history.valid?
      expect(history.errors[:office]).to include('を入力してください')
    end
  end
end
