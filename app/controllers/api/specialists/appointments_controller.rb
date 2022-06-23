class Api::Specialists::AppointmentsController < ApplicationController
  before_action :authenticate_specialist!

  def index
    data_length = current_specialist.office.appointments.length
    @appointments = current_specialist.office.appointments.limit(10).offset(params[:page].to_i * 10)
    render json: { appointments: @appointments, data_length: data_length }
  end
end
