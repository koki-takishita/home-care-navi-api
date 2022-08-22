require 'rails_helper'

RSpec.describe "Api::Customer::Bookmarks", type: :request do

  before(:each) do
    customer = build(:customer)
    customer.skip_confirmation!
    customer.save
    @customer = Customer.find_by_id(customer.id)
    @office = create(:office)
    @bookmark  = build(:bookmark, user: @customer, office: @office)

    specialist = build(:specialist)
    specialist.skip_confirmation!
    specialist.save
    @specialist = Specialist.find_by_id(specialist.id)
    @bookmark  = build(:bookmark, user: @specialist, office: @office)
  end

  context 'ログイン済み' do
    context 'カスタマー' do
      let(:auth_params) { login(@customer, @customer.user_type) }
      let(:bookmark) { create(:bookmark, user: @customer) }
      it "ブックマークを登録できる" do
          post api_office_bookmarks_path(@bookmark.office_id),
          params: {
            office_id: @bookmark.office_id,
            user_id: @customer.id
          },
          headers: auth_params

          getBookmark = Customer.first.bookmarks
          expect(getBookmark.count).to eq(1)
          expect(response).to have_http_status(200)
      end
      it "ブックマークを解除できる" do
          bookmark
          delete api_office_bookmark_path(bookmark.office_id, bookmark.id),
          params: {
            office_id: bookmark.office_id,
            user_id: @customer.id
          },
          headers: auth_params

          expect(@customer.bookmarks.count).to eq(0)
          expect(response).to have_http_status(200)
      end
    end

    context 'ケアマネ' do
      let(:auth_params) { login(@specialist, @specialist.user_type) }
      it "ブックマークを登録できない" do
        post api_office_bookmarks_path(@bookmark.office_id),
          params: {
            office_id: @bookmark.office_id,
            user_id: @specialist.id
          },
          headers: auth_params

          getBookmark = Specialist.first.bookmarks
          expect(getBookmark.count).to eq(0)
         expect(response).to have_http_status(401)
      end
    end
  end

  context 'ログインしていない' do
    let(:bookmark) { create(:bookmark, user: @customer) }
    it 'ブックマークを登録できない' do
      post api_office_bookmarks_path(@bookmark.office_id),
        params: {
          office_id: @bookmark.office_id,
          user_id: @customer.id
        }

        getBookmark = Customer.first.bookmarks
        expect(getBookmark.count).to eq(0)
        expect(response).to have_http_status(401)
    end
  end
end