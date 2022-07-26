class Api::Customer::ThanksController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_thank, only: [:update, :destroy, :show]

  # 戻り値 type: Hash
  # thanks: [
  #   {
  #     id: 1
  #     comments: "hogege",
  #     user_id: 1,
  #     office_id: 1,
  #     staff_id: 1
  #     staff: {
  #       name: "サンプル",
  #       kana: "さんぷる",
  #       image: 'http:hoehoge'
  #       office: {
  #         name: 'サンプルオフィス'
  #       },
  #     }
  #   },
  #   {
  #     id: 1
  #     comments: "hogege",
  #     user_id: 1,
  #     office_id: 1,
  #     staff_id: 1
  #     staff: {
  #       name: "サンプル",
  #       kana: "さんぷる",
  #       image: 'http:hoehoge'
  #       office: {
  #         name: 'サンプルオフィス2'
  #       },
  #     }
  #   },
  #   .
  #   .
  #   .
  # ],
  # {
  #   count: 999
  # }

  def index
    thanks = current_customer.thanks.order("updated_at DESC").order("created_at DESC").limit(10).offset(params[:page].to_i * 10)
    render json: { thank: thanks.as_json(include: {
                          staff: {only: [:name, :kana], methods: [:image_url], include: { office: { only: :name }}}}),
                            count: current_customer.thanks.count
                          }
  end

  def create
    customer = current_customer
    thank = customer.thanks.build(thank_params)
    if(thank.valid?)
      thank.save!
      render json: {
        message: 'お礼作成に成功しました'
      }, status: :ok
    else
      render json: {
        message: 'お礼作成に失敗しました',
        errors: thank.errors.full_messages
      }, status: 403
    end
  end

  def show
    render json: @thank.as_json
  end

  def update
    if @thank.update(thank_params)
      render json: {
        message: 'お礼を更新しました',
      }, status: :ok
    else
      render json: {
        message: '更新に失敗しました',
        errors: @thank.errors.full_messages
      }, status: 403
    end
  end

  def destroy
    @thank.destroy
    if @thank.destroyed?
      render json: {
        message: 'お礼を削除しました',
      }, status: :ok
    else
      render json: {
        message: 'お礼削除に失敗しました',
      }, status: 403
    end
  end

  private

  def thank_params
    params.require(:thank).permit(:comments, :office_id, :staff_id)
  end

  def set_thank
    @thank = current_customer.thanks.find(params[:id])
  end

end
