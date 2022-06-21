class Api::AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @appointments = Appointment.where(user_id: current_user.id)
    @office_id = current_user.appointments.pluck(:office_id)
    offices = Office.find(@office_id)
    render json: offices.to_json(:include => [:appointments], methods: [:image_url])
  end
end