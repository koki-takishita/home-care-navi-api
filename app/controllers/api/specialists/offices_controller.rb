class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!

  def show
    @office = current_specialist.office
    render json: @office
  end

  def create
    not_have_office = current_specialist.office.blank?
    not_have_office ? create_office : render_duplicate_error
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
      detail = office.build_office_detail(detail_params)
      if office.valid? && detail.valid?
        office.save!
        detail.save!
        render status: :ok, json: { message: 'オフィス作成成功' }
      else
        render status: :unauthorized, json: { errors: render_validation_error(office, detail) }
      end
    end

    def render_duplicate_error
      render status: :unauthorized, json: { errors: ['事業所はすでに存在します'] }
    end

    def render_validation_error(office, detail)
      errors = []
      office_erros = office.errors.full_messages
      office_detail_erros = detail.errors.full_messages

      office_erros.each do |office_error|
        errors.push(office_error)
      end

      office_detail_erros.each do |office_detail_error|
        errors.push(office_detail_error)
      end

      errors
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
