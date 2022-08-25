require 'rails_helper'

RSpec.describe 'Api::Contacts', type: :request do
  context '有効な情報' do
    it 'お問い合わせを登録できる' do
      post '/api/contacts',
           params: {
             name: 'サイト利用者',
             email: 'contact@example.com',
             types: 'ユーザー',
             content: 'サイト利用者よりお問い合わせをします。'
           }
      expect(Contact.count).to eq(1)
      expect(response).to have_http_status(:ok)
    end

    it 'お問い合わせのメールが届いている' do
      post '/api/contacts',
           params: {
             name: 'サイト利用者',
             email: 'contact@example.com',
             types: 'ユーザー',
             content: 'サイト利用者よりお問い合わせをします。'
           }
      expect(ActionMailer::Base.deliveries.size).to eq(1)
      expect(ActionMailer::Base.deliveries.first.body.parts[1].body.raw_source).to match(/サイト利用者 様 から問い合わせがありました。/)
      expect(ActionMailer::Base.deliveries.first.body.parts[1].body.raw_source).to match(/contact@example.com/)
      expect(ActionMailer::Base.deliveries.first.body.parts[1].body.raw_source).to match(/ユーザー/)
      expect(ActionMailer::Base.deliveries.first.body.parts[1].body.raw_source).to match(/サイト利用者よりお問い合わせをします。/)
    end
  end

  context '空の情報' do
    it 'お問い合わせを登録できない' do
      post '/api/contacts',
           params: {
             name: '',
             email: '',
             types: '',
             content: ''
           }
      expect(Contact.count).to eq(0)
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
