class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!

  def show
    @office = current_specialist.office
    render json: @office
  end

  def create
      string_to_actionController_parameters
      office = current_specialist.build_office(office_params)
      if office.valid?
        office.save!
        if !detail_params.empty?
          detail = office.build_office_detail(detail_params)
          if detail.valid?
            detail.save!
            render status: 200, json: "オフィス詳細作成成功"
          else
            render status: 401, json: { errors: detail.errors.full_messages, message: "オフィスのみ作成できました" }
          end
        else
          render status: 200, json: "オフィス作成成功"
        end
      else
        render status: 401, json: { errors: office.errors.full_messages }
      end
    end
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

  def string_to_actionController_parameters
    officeHash = json_parse(params[:office])
    officeHash.store("images", params[:officeImages])
    detailHash = json_parse(params[:detail])
    detailHash.store("images", params[:detailImages])
    @params = ActionController::Parameters.new({
      office: officeHash,
      detail: detailHash,
    })
  end

  def json_parse(json)
    JSON.parse(json)
  end
