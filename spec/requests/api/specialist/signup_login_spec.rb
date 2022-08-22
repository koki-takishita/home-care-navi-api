require 'rails_helper'

RSpec.describe 'Api::Specialists', type: :request do
  context 'ケアマネ' do
    let(:specialist) { build(:specialist) }

    it '新規登録できる' do
      post '/api/specialists/users',
           params: {
             name: specialist.name,
             email: specialist.email,
             password: specialist.password,
             password_confirmation: specialist.password_confirmation,
             phone_number: specialist.phone_number,
             post_code: specialist.post_code,
             address: specialist.address,
             confirm_success_url: 'localhost:8000/specialists/login'
           }
      expect(Specialist.count).to eq(1)
      expect(response).to have_http_status(:ok)
    end

    it 'ログインできる' do
      specialist.skip_confirmation!
      specialist.save
      authenticated_specialist = Specialist.find_by(id: specialist.id)
      login(authenticated_specialist, authenticated_specialist.user_type)
      expect(response).to have_http_status(:ok)
    end
  end

  context '登録済みカスタマー' do
    let(:customer) { build(:customer) }

    it 'ログインできない' do
      customer.skip_confirmation!
      customer.save
      authenticated_customer = Customer.find_by(id: customer.id)
      login(authenticated_customer, 'specialist')
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
