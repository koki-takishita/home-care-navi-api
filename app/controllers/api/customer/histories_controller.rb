class Api::Customer::HistoriesController < ApplicationController
  before_action :authenticate_customer!, only: %i[index create update]
  before_action :set_customer, only: %i[index create update]
  before_action :set_history, only: [:update]

  def index
    histories = @customer.histories.order(updated_at: :desc).limit(10)
    offices = get_office_from_histories(histories)
    result = if offices.count.zero?
               []
             else
               build_json(offices)
             end
    render json: result
  end

  def create
    history = @customer.histories.build(history_params)
    if history.valid?
      history.save!
      render json: {
        message: '閲覧データの登録に成功しました'
      }, status: :ok
    else
      render json: {
        message: '閲覧データの登録に失敗しました',
        errors: bookmark.errors.full_messages
      }, status: :forbidden
    end
  end

  def update
    # updated_atのみ更新
    # rubocop:disable Rails::SkipsModelValidations
    if @history.touch
    # rubocop:enable Rails::SkipsModelValidations
      render json: {
        message: '閲覧データを更新しました'
      }, status: :ok
    else
      render json: {
        message: '更新に失敗しました',
        errors: @history.errors.full_messages
      }, status: :forbidden
    end
  end

  def history_params
    params.permit(:office_id)
  end

  def set_history
    @history = @customer.histories.find(params[:id])
  end

  def set_customer
    @customer = current_customer
  end

  def get_office_from_histories(histories)
    offices_id = []
    histories.each_with_index.map do |history|
      offices_id.push(history.office_id)
    end
    Office.find(offices_id)
  end

  def build_json(offices)
    offices.each_with_index.map do |office|
      thank = { thank: { comments: office.latest_thank_comment } }
      detail      = { detail: office.detail }
      staff_count = { staffCount: office.staff_count }
      bookmark    = { bookmark: Bookmark.search_office_bookmark(office.id, current_customer.id).first }
      image       = { image: office.first_image_url }
      office      = office.attributes

      office.merge(thank, detail, image, staff_count, bookmark)
    end
  end
end
