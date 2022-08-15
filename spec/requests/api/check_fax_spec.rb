require 'rails_helper'

RSpec.describe "Checks", type: :request do
  describe "GET /check-fax-number" do

    before do
      create(:office,       fax_number: '080-0000-0004')
      end

    context 'officesに登録済みの電話番号' do
        it "他事業所でFAX番号あり、403が返ってくる" do
          get '/api/check-fax-number', :params => { fax_number: '080-0000-0004' }
          expect(response).to have_http_status(403)
        end
    end

    context '未登録の電話番号' do
      it "200が返ってくる" do
        get '/api/check-fax-number', :params => { fax_number: '080-0000-0005' }
        expect(response).to have_http_status(200)
      end
    end
  end
end
