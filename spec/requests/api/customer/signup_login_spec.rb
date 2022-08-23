require 'rails_helper'

RSpec.describe 'Api::Customer', type: :request do
  context 'カスタマー' do
    let(:customer) { build(:customer) }

    it '新規登録できる' do
      post '/api/customer',
           params: {
             name: customer.name,
             email: customer.email,
             password: customer.password,
             password_confirmation: customer.password_confirmation,
             phone_number: customer.phone_number,
             post_code: customer.post_code,
             address: customer.address,
             confirm_success_url: 'localhost:8000/customers/login'
           }
      expect(Customer.count).to eq(1)
      expect(response).to have_http_status(:ok)
    end

    it 'ログインできる' do
      customer.skip_confirmation!
      customer.save
      authenticated_customer = Customer.find_by(id: customer.id)
      login(authenticated_customer, authenticated_customer.user_type)
      expect(response).to have_http_status(:ok)
    end
  end

  context '登録済みケアマネ' do
    let(:specialist) { build(:specialist) }

    it 'ログインできない' do
      specialist.skip_confirmation!
      specialist.save
      authenticated_specialist = Specialist.find_by(id: specialist.id)
      login(authenticated_specialist, 'customer')
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
