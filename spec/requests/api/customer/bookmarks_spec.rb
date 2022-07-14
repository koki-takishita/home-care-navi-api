require 'rails_helper'
include ActionController::RespondWith

RSpec.describe "Api::Customer::Bookmarks", type: :request do

  before(:each) do
    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by_id(customer.id)
    @office = create(:office)
    @bookmark  = build(:bookmark, user: @customer, office: @office)

    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by_id(specialist.id)
    @bookmark  = build(:bookmark, user: @specialist, office: @office)
  end

  context 'ログイン済み' do
    context 'カスタマー' do
      it "ブックマークを登録できる" do
	    	login(@customer)
	    	auth_params = get_auth_params_from_login_response_headers(response)

          post api_office_bookmarks_path(@bookmark.office_id),
          params: {
            office_id: @bookmark.office_id,
            user_id: @customer.id
          },
          headers: auth_params

          getBookmark = Customer.first.bookmarks
          expect(getBookmark.count).to eq(1)
      end
    end

    context 'ケアマネ' do
      it "ブックマークを登録できない" do
	    	login(@specialist)
	    	auth_params = get_auth_params_from_login_response_headers(response)

        post api_office_bookmarks_path(@bookmark.office_id),
          params: {
            office_id: @bookmark.office_id,
            user_id: @specialist.id
          },
          headers: auth_params

          getBookmark = Specialist.first.bookmarks
          expect(getBookmark.count).to eq(0)
      end
    end
  end

  context 'ログインしていない' do
    it 'ブックマークを登録できない' do
      post api_office_bookmarks_path(@bookmark.office_id),
        params: {
          office_id: @bookmark.office_id,
          user_id: @customer.id
        }

        getBookmark = Customer.first.bookmarks
        expect(getBookmark.count).to eq(0)
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