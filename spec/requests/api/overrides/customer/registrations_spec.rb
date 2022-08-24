require 'rails_helper'

RSpec.describe 'Api::Customer', type: :request do
  before do
    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by(id: customer.id)
  end

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
      expect(Customer.count).to eq(2)
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

  context 'ログイン済みカスタマー' do
    let(:auth_params) { login(@customer, @customer.user_type) }

    it 'パスワードチェックが通る' do
      post api_users_path,
           params: {
             current_password: 'password'
           },
           headers: auth_params
      expect(response).to have_http_status(:ok)
    end

    it 'パスワードが違うと通らない' do
      post api_users_path,
           params: {
             current_password: 'password123'
           },
           headers: auth_params
      expect(response).to have_http_status(:unauthorized)
    end

    it '自分の情報を編集できる' do
      put '/api/customer',
          params: {
            name: '名前',
            email: 'test@test.com',
            password: 'password',
            password_confirmation: 'password',
            phone_number: '090-1234-5678',
            post_code: '123-4567',
            address: '住所',
            redirect_url: 'http://localhost:8000/users/login'
          },
          headers: auth_params
      updated_customer = Customer.find_by(id: @customer.id)
      expect(response).to have_http_status(:ok)
      expect(updated_customer.name).to eq('名前')
    end

    it '退会できる' do
      delete api_users_path,
             headers: auth_params
      expect(response).to have_http_status(:ok)
      expect(Customer.count).to eq(0)
    end
  end
end
