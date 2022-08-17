require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Api::Customer::Appointments", type: :request do

  before(:each) do
    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by_id(customer.id)
    @office = create(:office)
    @appointment  = build(:appointment, user: @customer, office: @office)

    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by_id(specialist.id)
    @appointment2 = build(:thank, user: @specialist, office: @office, staff: @staff)
  end

  context 'ログイン済み' do
    context 'カスタマー' do
      it "予約を作成できる" do
	    	login(@customer)
	    	auth_params = get_auth_params_from_login_response_headers(response)

        post api_office_appointments_path(@appointment.office_id),
        params: {
          meet_date: @appointment.meet_date,
          meet_time: @appointment.meet_time,
          name: @appointment.name,
          age: @appointment.name,
          phone_number: @appointment.phone_number,
          comment: @appointment.comment,
          called_status: 'need_call',
          user_id: @customer.id,
          office_id: @appointment.office_id
        },
        headers: auth_params

        getAppointment = User.first.appointments
        expect(getAppointment.count).to eq(1)
      end
    end

    context 'ケアマネ' do
      it "予約を作成できない" do
	    	login(@specialist)
	    	auth_params = get_auth_params_from_login_response_headers(response)

        post api_office_appointments_path(@appointment.office_id),
        params: {
          meet_date: @appointment.meet_date,
          meet_time: @appointment.meet_time,
          name: @appointment.name,
          age: @appointment.name,
          phone_number: @appointment.phone_number,
          comment: @appointment.comment,
          called_status: 'need_call',
          user_id: @specialist.id,
          office_id: @appointment.office_id
        },
        headers: auth_params

        getAppointment = User.first.appointments
        expect(getAppointment.count).to eq(0)
      end
    end
  end

  context 'ログインしていない' do
    it '予約を作成できない' do
      post api_office_appointments_path(@appointment.office_id),
      params: {
        meet_date: @appointment.meet_date,
        meet_time: @appointment.meet_time,
        name: @appointment.name,
        age: @appointment.name,
        phone_number: @appointment.phone_number,
        comment: @appointment.comment,
        called_status: 'need_call',
        user_id: @customer.id,
        office_id: @appointment.office_id
      }

      getAppointment = User.first.appointments
      expect(getAppointment.count).to eq(0)
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