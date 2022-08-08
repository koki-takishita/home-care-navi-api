require 'rails_helper'

RSpec.describe "Checks", type: :request do
  describe "GET /check-phone-number" do

    before do
      create(:customer,   phone_number: '080-0000-0000')
      create(:specialist, phone_number: '080-0000-0001')
      create(:office,     phone_number: '080-0000-0002')
    end

    context 'usersに登録済みの電話番号' do
      it "403が返ってくる" do
        get '/api/check-phone-number', :params => { phone_number: '080-0000-0000' }
        expect(response).to have_http_status(403)
      end

      it "403が返ってくる" do
        get '/api/check-phone-number', :params => { phone_number: '080-0000-0001' }
        expect(response).to have_http_status(403)
      end
    end

    context 'officesに登録済みの電話番号' do
      it "403が返ってくる" do
        get '/api/check-phone-number', :params => { phone_number: '080-0000-0002' }
        expect(response).to have_http_status(403)
      end
    end

    context '未登録の電話番号' do
      it "200が返ってくる" do
        get '/api/check-phone-number', :params => { phone_number: '080-0000-0003' }
        expect(response).to have_http_status(200)
      end
    end
  end
end
