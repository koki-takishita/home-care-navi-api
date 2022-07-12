require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Api::Specialists::Offices", type: :request do

  before(:each) do
    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by_id(specialist.id)
    @office = build(:office, user: @specialist)
  end

  context 'ログイン済み' do
    context 'スペシャリスト' do
      it "事業所を登録できる" do
        login(@specialist)
	    	auth_params = get_auth_params_from_login_response_headers(response)
        incoming_office_body = File.read(Rails.root.join("spec/fixtures/office_data.txt"))

        expect {
          post api_specialists_offices_path,
          params: incoming_office_body,
          headers: auth_params
        }#.to change(@specialist.office, :count).by(1)
        puts ""
        puts "事業所::#{@specialist.office}"
        puts ""
        # puts "事業所::#{@specialist.id}"
        # puts "事業所::#{@office.name}"
        # puts "事業所::#{@office.title}"
        # puts "事業所::#{@office.flags}"
        # puts "事業所::#{@office.business_day_detail}"
        # puts "事業所::#{@office.address}"
        # puts "事業所::#{@office.post_code}"
        # puts "事業所::#{@office.phone_number}"
        # puts "事業所::#{@office.fax_number}"
        # puts "事業所::#{@office.user_id}"
        # puts "事業所::#{@office.selected_flags}"
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