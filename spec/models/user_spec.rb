require 'rails_helper'

RSpec.describe User, type: :model do
  describe '新規登録' do
    before do
      @user = build(:user)
    end

    it '全ての項目が存在すれば登録できる' do
      expect(@user).to be_valid
    end

    it '重複したメールアドレスではアカウントが作れないこと' do
      create(:user, email: 'sample@gmail.com')
      @user = build(:user, email: 'sample@gmail.com')
      @user.valid?
      expect(@user.errors[:email]).to include('has already been taken')
    end

    it '重複した電話番号ではアカウントが作れないこと' do
      create(:user, phone_number: '11111111111')
      @user = build(:user, phone_number: '11111111111')
      @user.valid?
      expect(@user.errors[:phone_number]).to include('has already been taken')
    end
  end
end
