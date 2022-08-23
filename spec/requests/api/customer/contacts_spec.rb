require 'rails_helper'

RSpec.describe 'Api::Contacts', type: :request do
    context 'ログインしていない' do
        let(:contact) { create :contact }
        it 'お問い合わせを登録できる' do
          post '/api/contacts',
            params: {
              name: contact.name,
              email: contact.email,
              types: contact.types,
              content: contact.content,
            }
            expect(Contact.count).to eq(2)
            expect(response).to have_http_status(:ok)
        end
    end
    context '空の情報' do
        it 'お問い合わせを登録できない' do
            post '/api/contacts',
            params: {
                name: nil,
                email: nil,
                types: nil,
                content: nil,
            }
            expect(Contact.count).to eq(0)
            expect(response).to have_http_status(:unauthorized)
        end
    end
end

