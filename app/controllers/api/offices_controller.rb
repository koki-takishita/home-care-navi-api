class Api::OfficesController < ApplicationController
  before_action :set_office, only: [:show]

  def index
    offices = Office.all
    render json:{ data: offices }
  end

  def show
    render json: { data: @office }
  end

  private
   def set_office
      @office = Office.find(params[:id])
   end
end
