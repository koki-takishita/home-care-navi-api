require 'rails_helper'

RSpec.describe "Checks", type: :request do
  describe "GET /check-fax-number" do

    before do
      create(:customer,     phone_number: '080-0000-0002')
      create(:specialist,   phone_number: '080-0000-0003')
      create(:office,       phone_number: '080-0000-0004')
      create(:office,       fax_number: '080-0000-0005')
      end

      context 'ユーザーに登録済みの電話番号' do
        it "カスタマーで既に電話番号あり、403が返ってくる" do
          get '/api/check-phone-number', :params => { fax_number: '080-0000-0002' }
          expect(response).to have_http_status(403)
        end

        it "スペシャリストで既に電話番号あり、403が返ってくる" do
          get '/api/check-phone-number', :params => { fax_number: '080-0000-0003' }
          expect(response).to have_http_status(403)
        end
      end

      context 'officesで登録済みの電話番号' do
        it "他事業所で既に電話番号あり、403が返ってくる" do
          get '/api/check-phone-number', :params => { fax_number: '080-0000-0004' }
          expect(response).to have_http_status(403)
        end
      end

    context 'officesに登録済みのFAX番号' do
        it "他事業所で既にFAX番号あり、403が返ってくる" do
          get '/api/check-fax-number', :params => { fax_number: '080-0000-0005' }
          expect(response).to have_http_status(403)
        end
    end

    context '未登録の電話番号' do
      it "200が返ってくる" do
        get '/api/check-fax-number', :params => { fax_number: '080-0000-0006' }
        expect(response).to have_http_status(200)
      end
    end
  end
end
