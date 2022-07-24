require 'rails_helper'

RSpec.describe User, type: :model do
  describe '新規登録' do
    before do
      @user = FactoryBot.build(:user)
    end
    it '全ての項目が存在すれば登録できる' do
      expect(@user).to be_valid
    end
  it "重複したメールアドレスではアカウントが作れないこと" do
    FactoryBot.create(:user, email: "sample@gmail.com")
    @user = FactoryBot.build(:user, email: "sample@gmail.com")
    @user.valid?
    expect(@user.errors[:email].first).to include("すでに存在します")
   end
  it "重複した電話番号ではアカウントが作れないこと" do
    FactoryBot.create(:user, phone_number: "11111111111")
    @user = FactoryBot.build(:user, phone_number: "11111111111")
    @user.valid?
    expect(@user.errors[:phone_number].first).to include("すでに存在します")
   end
end

end