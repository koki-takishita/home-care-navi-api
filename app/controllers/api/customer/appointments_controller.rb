class Api::Customer::AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_office, only: [:create]

	def index
    appointments = current_user.appointments.order(created_at: :desc)
    offices = get_office_from_appointments(appointments)
    render json: offices, :include => {:appointments => {:only => [:meet_date, :meet_time, :called_status, :user_id, :created_at, :updated_at]}, :staffs => {:only => [:id]}}, methods: [:image_url]
  end

  def create
    params[:user_id] = current_user.id
    appointment = Appointment.new(appointment_params)
    if appointment.valid?
      appointment.save!
      render json: { status: 'success' }
    else
      render json: { status: appointment.errors.full_messages }
    end
  end

  private
    def appointment_params
      params.permit(:office_id, :meet_date, :meet_time, :name, :age, :phone_number, :comment, :user_id, :called_status)
    end

    def set_office
      @office = Office.find(params[:office_id])
    end

		def get_office_from_appointments(appointments)
			offices_id = []
			appointments.each_with_index.map{|appointment, index|
				offices_id.push(appointment.office_id)
			}
			offices = Office.find(offices_id)
			offices
		end
end
