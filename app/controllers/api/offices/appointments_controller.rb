class Api::Offices::AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_office, only: [:create]

  def create
    params[:user_id] = current_user.id
    appointment = Appointment.new(staff_params)
    if appointment.valid?
      appointment.save!
      render json: { status: 'success' }
    else
      render json: { status: appointment.errors.full_messages }
    end
  end

  private
    def staff_params
      params.permit(:office_id, :meet_date, :meet_time, :name, :age, :phone_number, :comment, :user_id, :called_status)
    end

    def set_office
      @office = Office.find(params[:office_id])
    end
end
