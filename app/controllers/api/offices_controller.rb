class Api::OfficesController < ApplicationController
  before_action :set_office, only: [:show]

  def index
    offices = Office.all
    render json:offices.as_json{ :offices }
  end

  def show
    render json: {office: @office, images: @office.image_url, staffs: @staffs}
  end

  private
    def set_office
      @office = Office.find(params[:id])
      @staffs = @office.staffs
    end
end
