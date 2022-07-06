require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Api::Customer::Thanks", type: :request do

  before(:each) do
    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by_id(customer.id)
    @office = create(:office, :with_staffs)
    @staff  = Staff.find_by(office_id: @office.id)
    @thank  = build(:thank, user: @customer, office: @office, staff: @staff)
  end

  it "if you are logged in can create thank msg" do
		login(@customer)
		auth_params = get_auth_params_from_login_response_headers(response)

    expect {
      post api_office_thanks_path(@thank.office_id),
      params: {
        thank: {
            comments: @thank.comments,
            office_id: @thank.office_id,
            staff_id: @thank.staff_id
          }
      },
      headers: auth_params
    }.to change(@customer.thanks, :count).by(1)
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
