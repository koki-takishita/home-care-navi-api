require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Api::Specialists::Offices", type: :request do

  before(:each) do
    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by_id(specialist.id)
    @office = build(:office, user: @specialist)

    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by_id(customer.id)

    @sampleImage = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/island.png'), 'image/png')
  end

  context 'ログイン済み' do
    context 'スペシャリスト' do
      it '事業所を登録できる' do
        login(@specialist)
	    	auth_params = get_auth_params_from_login_response_headers(response)

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
            expect(@specialist.office.images_blobs.blank?).to eq(false)
      end
    end

    context 'カスタマー' do
      it '事業所を登録できない' do
        login(@customer)
	    	auth_params = get_auth_params_from_login_response_headers(response)

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
      end
    end
  end

  def login(user)
    post api_login_path,
    params: { email: user.email, password: 'password' }
    .to_json,
    headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
	end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    auth_params = {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token-type' => token_type
    }
    auth_params
  end
end