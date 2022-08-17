require 'rails_helper'

RSpec.describe 'Appointmentモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Officeモデルとの関係' do
      it 'N:1となっている' do
        expect(Appointment.reflect_on_association(:office).macro).to eq :belongs_to
      end
    end

    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Appointment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
  end

  describe 'バリデーションのテスト' do
    it 'すべての項目の値が正しい場合、有効である' do
      appointment = build(:appointment)
      expect(appointment).to be_valid
    end

    it '面談日が今日以前の日付の場合、無効である' do
      appointment = build(:appointment, meet_date: Time.zone.today)
      appointment.valid?
      expect(appointment.errors[:meet_date]).to include('は、明日以降の日付を入力してください')
    end

    it '面談時間がない場合、無効である' do
      appointment = build(:appointment, meet_time: nil)
      appointment.valid?
      expect(appointment.errors[:meet_time]).to include('を入力してください')
    end

    it '名前がない場合、無効である' do
      appointment = build(:appointment, name: nil)
      appointment.valid?
      expect(appointment.errors[:name]).to include('を入力してください')
    end

    it '名前が31文字以上場合、無効である' do
      invalid_name = 'a' * 31
      appointment = build(:appointment, name: invalid_name)
      appointment.valid?
      expect(appointment.errors[:name]).to include('は30文字以内で入力してください')
    end

    it '年齢がない場合、無効である' do
      appointment = build(:appointment, age: nil)
      appointment.valid?
      expect(appointment.errors[:age]).to include('を入力してください')
    end

    it '電話番号がない場合、無効である' do
      appointment = build(:appointment, phone_number: nil)
      appointment.valid?
      expect(appointment.errors[:phone_number]).to include('を入力してください')
    end

    it '電話番号のフォーマットが適切でない場合、無効である' do
      # [ハイフンなし、{2~4桁}-{2~4桁}~{4桁}以外]
      invalid_phone_numbers = %w[09012345678 1-234-5678 123-45678-901 123-456-78901]
      invalid_phone_numbers.each do |invalid_phone_number|
        appointment = build(:appointment, phone_number: invalid_phone_number)
        appointment.valid?
        expect(appointment.errors[:phone_number]).to include('は不正な値です')
      end
    end

    it 'お困りごとがない場合、無効である' do
      appointment = build(:appointment, comment: nil)
      appointment.valid?
      expect(appointment.errors[:comment]).to include('を入力してください')
    end

    it '連絡済みかどうかのステータスがない場合、無効である' do
      appointment = build(:appointment, called_status: nil)
      appointment.valid?
      expect(appointment.errors[:called_status]).to include('を入力してください')
    end
  end
end
