require 'rails_helper'

RSpec.describe 'Contactのモデルテスト', type: :model do
  describe 'バリデーションテスト' do
    it 'すべての項目の値が正しい場合、有効である' do
      contact = build(:contact)
      expect(contact).to be_valid
    end

    it '名前がない場合、無効である' do
      contact = build(:contact, name: nil)
      contact.valid?
      expect(contact.errors[:name]).to include('を入力してください')
    end

    it '名前が31文字以上場合、無効である' do
      invalid_name = 'a' * 31
      contact = build(:contact, name: invalid_name)
      contact.valid?
      expect(contact.errors[:name]).to include('は30文字以内で入力してください')
    end

    it 'メールアドレスがない場合、無効である' do
      contact = build(:contact, email: nil)
      contact.valid?
      expect(contact.errors[:email]).to include('を入力してください')
    end

    it 'メールアドレスが256文字以上場合、無効である' do
      invalid_email = 'a' * 256
      contact = build(:contact, email: invalid_email)
      contact.valid?
      expect(contact.errors[:email]).to include('は255文字以内で入力してください')
    end

    it 'メールアドレスのフォーマットが適切でない場合、無効である' do
      invalid_emails = %w[あ@test.com test@あ test@test.あ test.com]
      invalid_emails.each do |invalid_email|
        @contact = build(:contact, email: invalid_email)
        @contact.valid?
        expect(@contact.errors[:email]).to include('は不正な値です')
      end
    end

    it '利用者区分がない場合、無効である' do
      contact = build(:contact, types: nil)
      contact.valid?
      expect(contact.errors[:types]).to include('を入力してください')
    end

    it 'お問い合わせ内容がない場合、無効である' do
      contact = build(:contact, content: nil)
      contact.valid?
      expect(contact.errors[:content]).to include('を入力してください')
    end
  end
end
