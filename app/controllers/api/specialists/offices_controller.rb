class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!

  def show
    @office = current_specialist.office
    render json: @office
  end

  def create
    not_have_office = current_specialist.office.blank?
    not_have_office ? create_office : render_error
  end

  private

    def office_params
      @params.require(:office)
             .permit(:name, :title, :flags, :business_day_detail, :address, :post_code, :phone_number, :fax_number, images: [])
    end

    def detail_params
      @params.require(:detail)
             .permit(:detail, :service_type, :open_date, :rooms, :requirement, :facility, :management, :link, :comment_1, :comment_2, images: [])
    end

    def create_office
      params_json_parse
      office = current_specialist.build_office(office_params)
      if office.valid?
        office.save!
        render status: :ok, json: { message: 'オフィス作成成功' }
        if detail_params.present?
          create_office_detail(office)
        end
      else
        render status: :unauthorized, json: { errors: office.errors.full_messages }
      end
    end

    def create_office_detail(office)
      detail = office.build_office_detail(detail_params)
      if detail.valid?
        detail.save!
      else
        render status: :unauthorized, json: { errors: detail.errors.full_messages, message: 'オフィスのみ作成できました' }
      end
    end

    def render_error
      render status: :unauthorized, json: { errors: ['事業所はすでに存在します'] }
    end

    def params_json_parse
      office_hash = JSON.parse(params[:office])
      office_hash.store('images', params[:officeImages])
      detail_hash = JSON.parse(params[:detail])
      detail_hash.store('images', params[:detailImages])
      @params = ActionController::Parameters.new({
                                                   office: office_hash,
                                                   detail: detail_hash
                                                 })
    end
end
