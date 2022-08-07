require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Api::Specialists::Staffs", type: :request do

  before(:each) do
    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by_id(specialist.id)
    @office = create(:office, user: @specialist)
    @staff = build(:staff, office: @office)
    @sampleImage = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/youngman.png'), 'image/png')
  end

  context 'ログイン済み' do
    context 'スペシャリスト' do
      it 'スタッフを登録できる' do
        login(@specialist)
	    	auth_params = get_auth_params_from_login_response_headers(response)
        post api_specialists_offices_staffs_path(@staff.office_id),
        params: {
          name: @staff.name,
          kana: @staff.kana,
          flags: @office.flags,
          introduction: @staff.introduction,
          image: @sampleImage,
          office_id: @staff.office_id
        },
        headers: auth_params

        getOffice = @specialist.office
        getStaff = getOffice.staffs.first
        expect(getOffice.staffs.count).to eq(1)
        expect(getStaff.image_blob.blank?).to eq(false)
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
          image: @sampleImage,
          office_id: @staff.office_id
        }

        getOffice = @specialist.office
        expect(getOffice.staffs.count).to eq(0)
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
