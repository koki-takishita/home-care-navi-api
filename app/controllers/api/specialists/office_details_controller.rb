class Api::Specialists::OfficeDetailsController < ApplicationController
  before_action :set_detail, only: [:show, :update]
  before_action :authenticate_specialist!

  def show
    render json: @office_detail, methods: [:image_url]
  end

  def create
    office_detail = Office_Detail.new(detail_params)
    if office_detail.valid?
      detail.save!
      render json: { status: 200}
    else
      render status: 401, json: { errors: office_detail.errors.full_messages }
    end
  end

  private
    def office_detail_params
      params.permit(:office_id, :detail, :service_type, :open_date, :rooms, :requirement, :facility, :management, :link)
    end

    def set_office_detail
      @office_detail = Office_Detail.find(params[:id])
      @office = Office.find(params[:office_id])
    end
  end
