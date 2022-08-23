require 'rails_helper'

RSpec.describe 'Api::Specialists::CareRecipients', type: :request do
  before do
    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by(id: specialist.id)
    @office = create(:office, user: @specialist)
    @staff = FactoryBot.create(:staff, office: @office)
    @sample_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/youngman.png'), 'image/png')
    @care_recipient = build(:care_recipient, office: @office, staff: @staff)
  end

  context 'ログイン済み' do
    let(:care_recipient) { create(:care_recipient, office: @office) }
    let(:before_name) { '利用者の名前' }
    let(:update_name) { '利用者の更新した名前' }

    context 'スペシャリスト' do
      let(:auth_params) { login(@specialist, @specialist.user_type) }

      it '利用者を登録できる' do
        post api_specialists_offices_care_recipients_path(@care_recipient.office_id),
             params: {
               name: @care_recipient.name,
               kana: @care_recipient.kana,
               post_code: @care_recipient.post_code,
               age: @care_recipient.age,
               address: @care_recipient.address,
               family: @care_recipient.family,
               image: @sample_image,
               staff_id: @care_recipient.staff_id,
               office_id: @care_recipient.office_id
             },
             headers: auth_params
    

        office = @specialist.office
        care_recipient = office.care_recipients.first
        expect(office.care_recipients.count).to eq(1)
        expect(care_recipient.image_blob.blank?).to be(false)
        expect(response).to have_http_status(:ok)
      end

      it '利用者を編集できる' do
        care_recipient
        put api_specialists_offices_care_recipient_path(care_recipient.id),
            params: {
              name: update_name
            },
            headers: auth_params

        office = @specialist.office
        care_recipient = office.care_recipients.first
        expect(care_recipient.name).to eq('利用者の更新した名前')
        expect(response).to have_http_status(:ok)
      end

      it '利用者を削除できる' do
        care_recipient
        delete api_specialists_offices_care_recipient_path(care_recipient.id),
               headers: auth_params
        
        office = @specialist.office
        expect(response).to have_http_status(:ok)
        expect(office.care_recipients.count).to eq(0)
      end
     end
  end
  context 'ログインしていない' do
    it '利用者を登録できない' do
      post api_specialists_offices_care_recipients_path(@care_recipient.office_id),
      params: {
        name: @care_recipient.name,
        kana: @care_recipient.kana,
        post_code: @care_recipient.post_code,
        age: @care_recipient.age,
        address: @care_recipient.address,
        family: @care_recipient.family,
        image: @sample_image,
        staff_id: @care_recipient.staff_id,
        office_id: @care_recipient.office_id
      }
      
      office = @specialist.office
      expect(office.care_recipients.count).to eq(0)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end