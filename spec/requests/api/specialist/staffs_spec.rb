require 'rails_helper'

RSpec.describe 'Api::Specialists::Staffs', type: :request do
  before do
    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by(id: specialist.id)
    @office = create(:office, user: @specialist)
    @staff = build(:staff, office: @office)
    @sample_image = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/youngman.png'), 'image/png')
  end

  context 'ログイン済み' do
    let(:staff) { create(:staff, office: @office) }
    let(:before_introduction) { 'スタッフの紹介文' }
    let(:update_introduction) { 'スタッフの紹介文を更新します' }

    context 'スペシャリスト' do
      let(:auth_params) { login(@specialist, @specialist.user_type) }

      it 'スタッフを登録できる' do
        post api_specialists_offices_staffs_path(@staff.office_id),
             params: {
               name: @staff.name,
               kana: @staff.kana,
               flags: @office.flags,
               introduction: @staff.introduction,
               image: @sample_image,
               office_id: @staff.office_id
             },
             headers: auth_params

        office = @specialist.office
        staff = office.staffs.first
        expect(office.staffs.count).to eq(1)
        expect(staff.image_blob.blank?).to be(false)
        expect(response).to have_http_status(:ok)
      end

      it 'スタッフを編集できる' do
        staff
        put api_specialists_offices_staff_path(staff.id),
            params: {
              introduction: update_introduction
            },
            headers: auth_params

        office = @specialist.office
        staff = office.staffs.first
        expect(staff.introduction).to eq('スタッフの紹介文を更新します')
        expect(response).to have_http_status(:ok)
      end

      it 'スタッフを削除できる' do
        staff
        delete api_specialists_offices_staff_path(staff.id),
               headers: auth_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ログインしていない' do
      it 'スタッフを登録できない' do
        post api_specialists_offices_staffs_path(@staff.office_id),
             params: {
               name: @staff.name,
               kana: @staff.kana,
               flags: @office.flags,
               introduction: @staff.introduction,
               image: @sample_image,
               office_id: @staff.office_id
             }

        office = @specialist.office
        expect(office.staffs.count).to eq(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end