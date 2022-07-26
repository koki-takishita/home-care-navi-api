class Api::Specialists::AppointmentsController < ApplicationController
  before_action :authenticate_specialist!
  before_action :set_office_appointment, only: [:update, :destroy]

  def index
    @data_length = current_specialist.office.appointments.length
    @order_called_status = current_specialist.office.appointments.order(:called_status, created_at: :desc)
    @appointments = @order_called_status.limit(10).offset(params[:page].to_i * 10)
    render json: { appointments: @appointments, data_length: @data_length }
  end

  def update
    if @appointment.valid?
      @appointment.update(appointment_params)
      render json: { status: 'success' }
    else
      render json: { status: @appointment.errors.full_messages }
    end
  end

  private
    def appointment_params
      params.permit(:called_status)
    end

    def set_office_appointment
      @appointment = current_specialist.office.appointments.find(params[:id])
    end
end
