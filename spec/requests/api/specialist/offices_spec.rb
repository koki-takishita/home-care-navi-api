require 'rails_helper'

RSpec.describe "Api::Specialists::Offices", type: :request do

  before(:each) do
    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by_id(specialist.id)
    @office = build(:office, user: @specialist)
    @sampleImage = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/island.png'), 'image/png')

    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by_id(customer.id)
  end

  context 'ログイン済み' do
    let(:office) { create(:office, user: @specialist) }
    context 'スペシャリスト' do
      let(:auth_params) { login(@specialist) }
      it '事業所を登録できる' do
        post api_specialists_offices_path,
        params: {
          name: @specialist.name,
          titie: @office.title,
          flags: @office.flags,
          business_day_detail: @office.business_day_detail,
          "images[]" => @sampleImage,
          address: @office.address,
          post_code: @office.post_code,
          fax_number: @office.fax_number,
          user_id: @specialist.id
        },
        headers: auth_params

        expect(Office.count).to eq(1)
        expect(@specialist.office.images.attached?).to eq(true)
        expect(response).to have_http_status(200)
      end

      it '事業所を複数登録できない' do
        office
        post api_specialists_offices_path,
        params: {
          name: @specialist.name,
          titie: @office.title,
          flags: @office.flags,
          business_day_detail: @office.business_day_detail,
          "images[]" => @sampleImage,
          address: @office.address,
          post_code: @office.post_code,
          fax_number: @office.fax_number,
          user_id: @specialist.id
        },
        headers: auth_params

        expect(Office.count).to eq(1)
        expect(response).to have_http_status(401)
      end
    end

    context 'カスタマー' do
      let(:auth_params) { login(@customer) }
      it '事業所を登録できない' do
        post api_specialists_offices_path,
        params: {
          name: @customer.name,
          titie: @office.title,
          flags: @office.flags,
          business_day_detail: @office.business_day_detail,
          "images[]" => @sampleImage,
          address: @office.address,
          post_code: @office.post_code,
          fax_number: @office.fax_number,
          user_id: @customer.id
        },
        headers: auth_params

        expect(Office.count).to eq(0)
        expect(response).to have_http_status(401)
      end
    end

    context 'ログインしていない' do
      it '事業所を登録できない' do
        post api_specialists_offices_path,
        params: {
          name: @specialist.name,
          titie: @office.title,
          flags: @office.flags,
          business_day_detail: @office.business_day_detail,
          "images[]" => @sampleImage,
          address: @office.address,
          post_code: @office.post_code,
          fax_number: @office.fax_number,
          user_id: @specialist.id
        }
        expect(Office.count).to eq(0)
        expect(response).to have_http_status(401)
      end
    end
  end
end
