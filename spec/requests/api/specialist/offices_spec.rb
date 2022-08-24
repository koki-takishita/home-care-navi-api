require 'rails_helper'

RSpec.describe 'Api::Specialists::Offices', type: :request do
  before do
    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by(id: specialist.id)
    @office = build(:office, user: @specialist)
    @sampleImage = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/island.png'), 'image/png')

    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by(id: customer.id)
  end

  context 'ログイン済み' do
    let(:office) { create(:office, user: @specialist) }

    context 'スペシャリスト' do
      let(:auth_params) { login(@specialist, @specialist.user_type) }

      it '事業所を登録できる' do
        post api_specialists_offices_path,
             params: {
               office: {
                 name: @specialist.name,
                 titie: @office.title,
                 flags: @office.flags,
                 business_day_detail: @office.business_day_detail,
                 address: @office.address,
                 post_code: @office.post_code,
                 fax_number: @office.fax_number,
                 user_id: @specialist.id
               }.to_json,
               detail: {
                 detail: '特徴詳細',
                 service_type: '介護付きホーム',
                 open_date: '',
                 rooms: '',
                 requirement: '',
                 facility: '',
                 management: '',
                 link: '',
                 comment_1: '',
                 comment_2: ''
               }.to_json,
               officeImages: [@sampleImage]
             },
             headers: auth_params
        expect(Office.count).to eq(1)
        expect(@specialist.office.images.attached?).to be(true)
        expect(response).to have_http_status(:ok)
      end

      it '事業所を複数登録できない' do
        office
        post api_specialists_offices_path,
             params: {
               office: {
                 name: @specialist.name,
                 titie: office.title,
                 flags: office.flags,
                 business_day_detail: office.business_day_detail,
                 officeImages: @sampleImage,
                 address: office.address,
                 post_code: office.post_code,
                 fax_number: office.fax_number,
                 user_id: @specialist.id
               }.to_json,
               detail: {
                 detail: '特徴詳細',
                 service_type: '介護付きホーム',
                 open_date: '',
                 rooms: '',
                 requirement: '',
                 facility: '',
                 management: '',
                 link: '',
                 comment_1: '',
                 comment_2: ''
               }.to_json
             },
             headers: auth_params
        expect(Office.count).to eq(1)
        expect(response).to have_http_status(:unauthorized)
      end

      context 'fax_number' do
        context '値が空' do
          it '値がnilとして保存される' do
            post api_specialists_offices_path,
                 params: {
                   office: {
                     name: @specialist.name,
                     titie: @office.title,
                     flags: @office.flags,
                     business_day_detail: @office.business_day_detail,
                     officeImages: @sampleImage,
                     address: @office.address,
                     post_code: @office.post_code,
                     fax_number: '',
                     user_id: @specialist.id
                   }.to_json,
                   detail: {
                     detail: '特徴詳細',
                     service_type: '介護付きホーム',
                     open_date: '',
                     rooms: '',
                     requirement: '',
                     facility: '',
                     management: '',
                     link: '',
                     comment_1: '',
                     comment_2: ''
                   }.to_json
                 },
                 headers: auth_params
            expect(Office.count).to eq(1)
            expect(Office.last.fax_number).to be_nil
          end
        end

        context '登録済みの値' do
          it '登録できない' do
            create(:office, fax_number: '080-0707-0606')
            post api_specialists_offices_path,
                 params: {
                   office: {
                     name: @specialist.name,
                     titie: @office.title,
                     flags: @office.flags,
                     business_day_detail: @office.business_day_detail,
                     officeImages: @sampleImage,
                     address: @office.address,
                     post_code: @office.post_code,
                     fax_number: '080-0707-0606',
                     user_id: @specialist.id
                   }.to_json,
                   detail: {
                     detail: '特徴詳細',
                     service_type: '介護付きホーム',
                     open_date: '',
                     rooms: '',
                     requirement: '',
                     facility: '',
                     management: '',
                     link: '',
                     comment_1: '',
                     comment_2: ''
                   }.to_json
                 },
                 headers: auth_params
            expect(Office.count).to eq(1)
            expect(response).to have_http_status(:unauthorized)
          end

          it '登録できる' do
            create(:office, fax_number: '')
            post api_specialists_offices_path,
                 params: {
                   office: {
                     name: @specialist.name,
                     titie: @office.title,
                     flags: @office.flags,
                     business_day_detail: @office.business_day_detail,
                     officeImages: @sampleImage,
                     address: @office.address,
                     post_code: @office.post_code,
                     fax_number: '',
                     user_id: @specialist.id
                   }.to_json,
                   detail: {
                     detail: '特徴詳細',
                     service_type: '介護付きホーム',
                     open_date: '',
                     rooms: '',
                     requirement: '',
                     facility: '',
                     management: '',
                     link: '',
                     comment_1: '',
                     comment_2: ''
                   }.to_json
                 },
                 headers: auth_params
            expect(Office.count).to eq(2)
            expect(response).to have_http_status(:ok)
          end
        end
      end
    end

    context 'カスタマー' do
      let(:auth_params) { login(@customer, @customer.user_type) }

      it '事業所を登録できない' do
        post api_specialists_offices_path,
             params: {
               office: {
                 name: @specialist.name,
                 titie: @office.title,
                 flags: @office.flags,
                 business_day_detail: @office.business_day_detail,
                 officeImages: @sampleImage,
                 address: @office.address,
                 post_code: @office.post_code,
                 fax_number: @office.fax_number,
                 user_id: @specialist.id
               }.to_json,
               detail: {
                 detail: '特徴詳細',
                 service_type: '介護付きホーム',
                 open_date: '',
                 rooms: '',
                 requirement: '',
                 facility: '',
                 management: '',
                 link: '',
                 comment_1: '',
                 comment_2: ''
               }.to_json
             },
             headers: auth_params
        expect(Office.count).to eq(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'ログインしていない' do
      it '事業所を登録できない' do
        post api_specialists_offices_path,
             params: {
               office: {
                 name: @specialist.name,
                 titie: @office.title,
                 flags: @office.flags,
                 business_day_detail: @office.business_day_detail,
                 officeImages: @sampleImage,
                 address: @office.address,
                 post_code: @office.post_code,
                 fax_number: @office.fax_number,
                 user_id: @specialist.id
               }.to_json,
               detail: {
                 detail: '特徴詳細',
                 service_type: '介護付きホーム',
                 open_date: '',
                 rooms: '',
                 requirement: '',
                 facility: '',
                 management: '',
                 link: '',
                 comment_1: '',
                 comment_2: ''
               }.to_json
             }
        expect(Office.count).to eq(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
