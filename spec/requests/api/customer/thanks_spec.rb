require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Api::Customer::Thanks", type: :request do
  before(:each) do
    @current_user = FactoryBot.build(:user)
    @current_user.skip_confirmation!
    @current_user.save 
		@customer = create(:user, :customer)
		@specialist = create(:user, :specialist)
		@office = create(:office, user: @specialist)
		#@office_user_exist = build(:office, specialist: @specialist)
  end

  it "if you are logged in can create thank msg" do
		login
		auth_params = get_auth_params_from_login_response_headers(response)
		puts @specialist.attributes
  end

	def login
    post api_login_path, params:  { email: @current_user.email, password: 'password' }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
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
