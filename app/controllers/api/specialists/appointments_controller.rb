class Api::Specialists::AppointmentsController < ApplicationController
  include ActionController::MimeResponds
  def index
    # オフィス.予約.user
    # ユーザーに紐づく予約でなく、予約に紐づくユーザー
    @appointments = current_specialist.office.appointments
    @user_id = @appointments.pluck(:user_id)
    @user = User.find(@user_id)
    render json: @user.to_json(:include => [:appointments])
    # render json: @user.to_json(:include => [:appointments])
    # render json: { appointments: @appointments, include: [:user] }
  end
end
