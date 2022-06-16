class Api::Specialists::OfficeDetailsController < ApplicationController
  before_action :set_detail, only: [:show, :update]
  before_action :authenticate_specialist!

  def index
    @details = current_specialist.office.details
    render json: @details, methods: [:image_url]
  end

  def show
    render json: @detail, methods: [:image_url]
  end

  def create
    detail = Detail.new(detail_params)
    if detail.valid?
      detail.save!
      render json: { status: 200}
    else
      render status: 401, json: { errors: office_detail.errors.full_messages }
    end
  end

  def update
    if @detail.valid?
      @detail.update(detail_params)
      render json: { status: 'success' }
    else
    render json: { status: detail.errors.full_messages }
    end
  end

  private

    def detail_params
      params.permit(:office_id, :detail, :service_type, :open_date, :rooms, :requirement, :facility, :management, :link)
    end

    def set_detail
      @detail = Detail.find(params[:id])
      @office = Office.find(params[:office_id])
    end
  end
