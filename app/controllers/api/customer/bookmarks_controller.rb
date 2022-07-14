class Api::Customer::BookmarksController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_bookmark, only: [:destroy]

  def index
    if user_signed_in?
      bookmark = Bookmark.where(office_id: params[:office_id], user_id: current_customer.id)
    else
      bookmark = null
    end
    render json: { bookmark: bookmark }
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
end
