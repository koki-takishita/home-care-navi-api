require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Officeモデルとの関係' do
      it '1:1となっている' do
        expect(User.reflect_on_association(:office).macro).to eq :has_one
      end
    end

    context 'Appointmentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:appointments).macro).to eq :has_many
      end
    end

    context 'Thankモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:thanks).macro).to eq :has_many
      end
    end

    context 'Bookmarkモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:bookmarks).macro).to eq :has_many
      end
    end

    context 'Historyモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:histories).macro).to eq :has_many
      end
    end
  end

  describe 'バリデーションのテスト' do
    before do
      @user = build(:user)
    end

    it 'すべての項目の値が正しい場合、有効である' do
      expect(@user).to be_valid
    end

    it '名前がない場合、無効である' do
      @user = build(:user, name: nil)
      @user.valid?
      expect(@user.errors[:name]).to include('を入力してください')
    end

    it '名前が31文字以上の場合、無効である' do
      invalid_name = 'a' * 31
      @user = build(:user, name: invalid_name)
      @user.valid?
      expect(@user.errors[:name]).to include('は30文字以内で入力してください')
    end

    it 'メールアドレスがない場合、無効である' do
      @user = build(:user, email: nil)
      @user.valid?
      expect(@user.errors[:email]).to include('を入力してください')
    end

    it 'メールアドレスが256文字以上の場合、無効である' do
      # 全部で256文字のemail
      invalid_email = 'a' * 256
      @user = build(:user, email: invalid_email)
      @user.valid?
      expect(@user.errors[:email]).to include('は255文字以内で入力してください')
    end

    it 'メールアドレスのフォーマットが適切でない場合、無効である' do
      # https://qiita.com/HIROKOBA/items/1358aa2e9652688698ee
      # [ @以前に英数字、アンダースコア (_)、プラス (+)、ハイフン (-)、ドット (.)を含まないもの、
      #   @以降に英数字、アンダースコア (_)、プラス (+)、ハイフン (-)、ドット (.)を含まないもの、
      #   ドット以降に英小文字を含まないもの、
      #   @のないもの
      # ]
      invalid_emails = %w[あ@test.com test@あ test@test.あ test.com]
      invalid_emails.each do |invalid_email|
        @user = build(:user, email: invalid_email)
        @user.valid?
        expect(@user.errors[:email]).to include('は不正な値です')
      end
    end

    it 'メールアドレスが重複している場合、無効である' do
      create(:user, email: 'test@test.com')
      @user = build(:user, email: 'test@test.com')
      @user.valid?
      expect(@user.errors[:email]).to include('はすでに存在します')
    end

    it 'パスワードがない場合、無効である' do
      @user.password = nil
      @user.valid?
      expect(@user.errors[:password]).to include('を入力してください')
    end

    it 'パスワードが8文字未満である場合、無効である' do
      invalid_password = 'a' * 7
      @user.password = invalid_password
      @user.valid?
      expect(@user.errors[:password]).to include('は8文字以上で入力してください')
    end

    it 'パスワードが33文字以上である場合、無効である' do
      invalid_password = 'a' * 33
      @user.password = invalid_password
      @user.valid?
      expect(@user.errors[:password]).to include('は32文字以内で入力してください')
    end

    it '電話番号がない場合、無効である' do
      @user = build(:user, phone_number: nil)
      @user.valid?
      expect(@user.errors[:phone_number]).to include('を入力してください')
    end

    it '電話番号のフォーマットが適切でない場合、無効である' do
      # [ハイフンなし、{2~4桁}-{2~4桁}~{4桁}以外]
      invalid_phone_numbers = %w[09012345678 1-234-5678 123-45678-901 123-456-78901]
      invalid_phone_numbers.each do |invalid_phone_number|
        @user = build(:user, phone_number: invalid_phone_number)
        @user.valid?
        expect(@user.errors[:phone_number]).to include('は不正な値です')
      end
    end

    it '電話番号が重複している場合、無効である' do
      create(:user, phone_number: '111-1111-1111')
      @user = build(:user, phone_number: '111-1111-1111')
      @user.valid?
      expect(@user.errors[:phone_number]).to include('はすでに存在します')
    end

    it '郵便番号がない場合、無効である' do
      @user = build(:user, post_code: nil)
      @user.valid?
      expect(@user.errors[:post_code]).to include('を入力してください')
    end

    it '郵便番号のフォーマットが適切でない場合、無効である' do
      # [ハイフンなし、{3桁}-{4桁}以外]
      invalid_post_codes = %w[1234567 12-3456 123-456]
      invalid_post_codes.each do |invalid_post_code|
        @user = build(:user, post_code: invalid_post_code)
        @user.valid?
        expect(@user.errors[:post_code]).to include('は不正な値です')
      end
    end

    it '住所がない場合、無効である' do
      @user = build(:user, address: nil)
      @user.valid?
      expect(@user.errors[:address]).to include('を入力してください')
    end
  end
end
