require 'rails_helper'

RSpec.describe 'Api::Customer::Bookmarks', type: :request do
  before do
    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by(id: customer.id)
    @office = create(:office)
    @history  = build(:history, user: @customer, office: @office)

    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by(id: specialist.id)
    @history2 = build(:history, user: @specialist, office: @office)
  end

  context 'ログイン済み' do
    context 'カスタマー' do
      let(:auth_params) { login(@customer) }
      let(:history) { create(:history, user: @customer) }

      it '閲覧データを登録できる' do
        post api_office_histories_path(@history.office.id),
             params: {
               user_id: @customer.id,
               office_id: @history.office.id
             },
             headers: auth_params

        history = @customer.histories
        expect(history.count).to eq(1)
        expect(response).to have_http_status(:ok)
      end

      it '閲覧データを更新できる' do
        history
        put api_office_history_path(history.office_id, history.id),
            params: {
              user_id: history.user_id,
              office_id: history.office_id
            },
            headers: auth_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'ケアマネ' do
      it '閲覧データを登録できない' do
        auth_params = login(@specialist)
        post api_office_histories_path(@history.office.id),
             params: {
               user_id: @specialist.id,
               office_id: @history.office.id
             },
             headers: auth_params

        history = @specialist.histories
        expect(history.count).to eq(0)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
