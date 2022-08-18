class Api::Customer::AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_office, only: [:create]

  def index
    appointments = current_user.appointments.order(created_at: :desc)
    render json: { appointment: appointments.as_json(only: %i[meet_date meet_time called_status created_at], include: {
                                                       office: { only: %i[id name phone_number], methods: %i[first_image_url staff_count] }
                                                     }) }
  end

  def create
    params[:user_id] = current_user.id
    appointment = Appointment.new(appointment_params)
    if appointment.valid?
      appointment.save!
      render status: :ok, json: { message: '予約作成に成功しました' }
    else
      render status: :unprocessable_entity, json: { errors: appointment.errors.full_messages }
    end
  end

  private

    def appointment_params
      params.permit(:office_id, :meet_date, :meet_time, :name, :age, :phone_number, :comment, :user_id, :called_status)
    end

    def set_office
      @office = Office.find(params[:office_id])
    end
end
