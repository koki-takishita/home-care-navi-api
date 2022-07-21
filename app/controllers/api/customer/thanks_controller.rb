class Api::Customer::ThanksController < ApplicationController
  before_action :authenticate_customer!

  # 戻り値 type: Array
  # [
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
  #   {
  #     count: 999
  #   }
  # ]
  def index
    thanks = current_customer.thanks.order("created_at DESC").order("updated_at DESC").limit(10).offset(params[:page].to_i * 10)
    #methods: [:create_thanks_count(current_customer.id)]
    render json: thanks.as_json(include: {
                                    staff: { only: [:name, :kana], methods: [:image_url], include: { office: { only: :name }}}
                                    }).push({count: current_customer.thanks.count})
  end

  def create
    customer = current_customer
    thank = customer.thanks.build(thank_params)
    if(thank.valid?)
      thank.save!
      render json: {
        status: 'success',
        message: 'お礼作成に成功しました'
      }
    else
      render json: {
        status: 'danger',
        message: 'お礼作成に失敗しました'
      }
    end
  end

  private

  def thank_params
    params.require(:thank).permit(:comments, :office_id, :staff_id)
  end

end
