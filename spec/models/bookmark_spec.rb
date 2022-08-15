require 'rails_helper'

RSpec.describe 'Bookmarkモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Bookmark.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Officeモデルとの関係' do
      it 'N:1となっている' do
        expect(Bookmark.reflect_on_association(:office).macro).to eq :belongs_to
      end
    end
  end

  describe 'バリデーションのテスト' do
    it 'ユーザーidと事業所idがある場合、有効である' do
      bookmark = build(:bookmark)
      expect(bookmark).to be_valid
    end

    it 'ユーザーidがない場合、無効である' do
      bookmark = build(:bookmark, user_id: nil)
      bookmark.valid?
      expect(bookmark.errors[:user]).to include('を入力してください')
    end

    it '事業所idがない場合、無効である' do
      bookmark = build(:bookmark, office_id: nil)
      bookmark.valid?
      expect(bookmark.errors[:office]).to include('を入力してください')
    end
  end
end
