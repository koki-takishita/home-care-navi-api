class Api::Customer::BookmarksController < Api::Customer::OfficesController
  before_action :authenticate_customer!, only: [:create, :destroy]
  before_action :set_bookmark, only: [:destroy]

  def index
    if customer_signed_in?
      bookmarks = current_customer.bookmarks.order(created_at: :desc)
      offices = get_office_from_bookmarks(bookmarks)
      result = if(offices.size <= 0)
        []
      else
        build_json(offices)
      end
      render json: result
    else
      render json: []
    end
  end

  def create
    customer = current_customer
    bookmark = customer.bookmarks.build(bookmark_params)
    if(bookmark.valid?)
      bookmark.save!
      render json: {
        message: 'ブックマーク登録に成功しました'
      }, status: :ok
    else
      render json: {
        message: 'ブックマーク登録に失敗しました',
        errors: bookmark.errors.full_messages
      }, status: 403
    end
  end

  def destroy
    if @bookmark.valid?
      @bookmark.destroy
      render json: {
        message: 'ブックマーク解除に成功しました'
      }, status: :ok
    else
      render json: {
        message: 'ブックマーク解除に失敗しました',
        errors: @bookmark.errors.full_messages
      }, status: 403
    end
  end

  private

  def bookmark_params
    params.permit(:office_id)
  end

  def set_bookmark
    @bookmark = current_customer.bookmarks.find(params[:id])
  end

  def get_office_from_bookmarks(bookmarks)
    offices_id = []
    bookmarks.each_with_index.map{|bookmark, index|
      offices_id.push(bookmark.office_id)
    }
    offices = Office.find(offices_id)
    offices
  end

  def build_json(offices)
    result = offices.each_with_index.map{|office, index|
     superClass = Api::Customer::BookmarksController.new
     thank = superClass.build_json_from_thank_table_attributes(office)
     detail = superClass.build_json_from_detail_table_attributes(office)
     staff_count = superClass.build_json_from_staff_table_count_json(office)
     bookmark    = build_json_from_bookmark_table(office)
     image       = superClass.build_json_image(office)
     office      = office.attributes

     result = if(index == 0)
      office.merge(thank, detail, image, staff_count, bookmark, {count: offices.count})
              else
                office.merge(thank, detail, image, staff_count, bookmark)
              end
    }
    result
  end

  def build_json_from_bookmark_table(office)
    bookmarks = office.bookmarks.where(user_id: current_customer.id)
    { bookmark: bookmarks.first }
  end
end
