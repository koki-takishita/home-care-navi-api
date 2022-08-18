class Api::Customer::BookmarksController < ApplicationController
  before_action :authenticate_customer!, only: %i[create destroy]
  before_action :bookmark, only: [:destroy]

  def index
    bookmarks = current_customer.bookmarks.order(created_at: :desc).limit(10).offset(params[:page].to_i * 10)
    offices = office_from_bookmarks(bookmarks)
    result = if offices.count <= 0
               []
             else
               build_json(offices)
             end
    render json: result
  end

  def create
    customer = current_customer
    bookmark = customer.bookmarks.build(bookmark_params)
    if bookmark.valid?
      bookmark.save!
      render status: :ok, json: { message: 'ブックマーク登録に成功しました' }
    else
      render status: :forbidden, json: { errors: bookmark.errors.full_messages }
    end
  end

  def destroy
    if @bookmark.valid?
      @bookmark.destroy
      render status: :ok, json: { message: 'ブックマーク解除に成功しました' }
    else
      render status: :forbidden, json: { errors: @bookmark.errors.full_messages }
    end
  end

  private

    def bookmark_params
      params.permit(:office_id)
    end

    def bookmark
      @bookmark = current_customer.bookmarks.find(params[:id])
    end

    def office_from_bookmarks(bookmarks)
      offices_id = []
      bookmarks.each_with_index.map do |bookmark, _index|
        offices_id.push(bookmark.office_id)
      end
      Office.find(offices_id)
    end

    def build_json(offices)
      offices.each_with_index.map do |office, index|
        thank = { thank: { comments: office.latest_thank_comment } }
        detail = { detail: office.detail }
        staff_count = { staffCount: office.staff_count }
        bookmark    = { bookmark: Bookmark.search_office_bookmark(office.id, current_customer.id).first }
        image       = { image: office.first_image_url }
        count = current_customer.bookmarks.count
        office      = office.attributes

        result = if index.zero?
                   office.merge(thank, detail, image, staff_count, bookmark, { count: count })
                 else
                   office.merge(thank, detail, image, staff_count, bookmark)
                 end
        result
      end
    end
end
