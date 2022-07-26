require 'rails_helper'

RSpec.describe "Api::Customer::Thanks", type: :request do

  describe "お礼機能" do
    before do
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

      let(:thank) { create(:thank, user: @customer) }
      let(:before_comment) { 'ありがとう、素晴らしい対応でした' }
      let(:update_comment) { "#{thank.staff.name}さん、ありがとうございました!!" }

      context 'カスタマー' do
        let(:auth_params) { login(@customer) }

        context "お礼作成" do
          it "お礼を作成できる" do
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
            expect(response).to have_http_status(200)
          end

          it "同じスタッフにはお礼を作成できない" do
            thank
            post api_office_thanks_path(thank.office_id),
            params: {
              thank: {
                  comments: thank.comments,
                  office_id: thank.office_id,
                  staff_id: thank.staff_id
                }
            },
            headers: auth_params
            expect(response).to have_http_status(403)
          end
        end

        it "お礼を編集できる" do
          thank
          expect {
            put api_thank_path(thank.id),
            params: {
              thank: {
                  comments: update_comment
                }
            },
            headers: auth_params
          }.to change{ Thank.first.comments }.from(before_comment).to(update_comment)
          expect(response).to have_http_status(200)
        end

        it "お礼を削除できる" do
          thank
          delete api_thank_path(thank.id),
          headers: auth_params
          expect(response).to have_http_status(200)
        end
        
        it "お礼を取得できる" do
          thank
          get api_thank_path(thank.id),
          headers: auth_params
          expect(response).to have_http_status(200)
        end
        
      end

      context 'ケアマネ' do
        it "お礼を作成できない" do
          auth_params = login(@specialist)
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

        it "お礼を編集できない" do
          auth_params = login(@specialist)
          put api_thank_path(thank.id),
          params: {
            thank: {
                comments: update_comment
              }
          },
          headers: auth_params
          expect(response).to have_http_status(401)
        end
      end
    end
    
    context 'ログインしていない' do
    
      let(:thank) { create(:thank, user: @customer) }
      let(:update_comment) { "#{thank.staff.name}さん、ありがとうございました!!" }

    context 'ログインしていない' do

      let(:thank) { create(:thank, user: @customer) }
      let(:update_comment) { "#{thank.staff.name}さん、ありがとうございました!!" }

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
        expect(response).to have_http_status(401)
      end

      it "お礼を編集できない" do
        put api_thank_path(thank.id),
        params: {
          thank: {
              comments: update_comment
            }
        }
        expect(response).to have_http_status(401)
      end
    end
  end
end
