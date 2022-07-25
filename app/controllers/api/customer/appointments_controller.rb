class Api::Customer::AppointmentsController < Api::Customer::OfficesController
  before_action :authenticate_user!
  before_action :set_office, only: [:create]

	def index
    appointments = current_user.appointments.order(created_at: :desc)
    offices = get_office_from_appointments(appointments)
		result = if offices.size <= 0
                []
             else
							build_json(offices)
             end
						 render json: result
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

		def build_json(offices)
			result = offices.each_with_index.map{|office|
				superClass  = Api::Customer::AppointmentsController.new
				image       = superClass.build_json_image(office)
				staff_count = superClass.build_json_from_staff_table_count_json(office)
				appointment = build_json_from_appointments_table_json(office)
				office      = office.attributes

				office.merge(image, staff_count, appointment)
			 }
			 result
		end

		def build_json_from_appointments_table_json(office)
			if office.appointments.exists?
        appointments = office.appointments.where(user_id: current_customer.id)
				latest_office_appointment = appointments.order(created_at: :desc).first
        { appointment: latest_office_appointment }
      else
        { appointment: nil}
      end
		end
end
