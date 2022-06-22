class Api::Specialists::AppointmentsController < ApplicationController
  include ActionController::MimeResponds
  def index
    @appointments = current_specialist.office.appointments
    render json: { appointments: @appointments }
  end
end
