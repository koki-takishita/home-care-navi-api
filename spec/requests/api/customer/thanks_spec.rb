require 'rails_helper'

RSpec.describe "Api::Customer::Thanks", type: :request do

  before(:each) do
    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by_id(customer.id)
    @office = create(:office, :with_staffs)
    @staff  = Staff.find_by(office_id: @office.id)
    @thank  = build(:thank, user: @customer, office: @office, staff: @staff)
    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by_id(specialist.id)
    @thank2 = build(:thank, user: @specialist, office: @office, staff: @staff)
  end

  context 'ログイン済み' do
    context 'カスタマー' do
      it "お礼を作成できる" do
        auth_params = login(@customer)
        expect {
          post api_office_thanks_path(@thank.office_id),
          params: {
            thank: {
                comments: @thank.comments,
                office_id: @thank.office_id,
                staff_id: @thank.staff_id
              }
          },
          headers: auth_params
        }.to change(@customer.thanks, :count).by(1)
      end
    end

    context 'ケアマネ' do
      it "お礼を作成できない" do
        auth_params = login(@customer)
        expect {
          post api_office_thanks_path(@thank.office_id),
          params: {
            thank: {
                comments: @thank.comments,
                office_id: @thank.office_id,
                staff_id: @thank.staff_id
              }
          },
          headers: auth_params
        }.to change(@specialist.thanks, :count).by(0)
      end
    end
  end

  context 'ログインしていない' do
    it 'お礼を作成できない' do
      expect {
        post api_office_thanks_path(@thank.office_id),
        params: {
          thank: {
              comments: @thank.comments,
              office_id: @thank.office_id,
              staff_id: @thank.staff_id
            }
        }
      }.to change(@specialist.thanks, :count).by(0)
    end
  end
end
