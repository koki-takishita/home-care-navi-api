class Api::AppointmentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @appointments = Appointment.where(user_id: current_user.id)
    @office_id = current_user.appointments.pluck(:office_id)
    offices = Office.find(@office_id)
    sort_offices = []
    appointments_created_ats = []
    appointments_created_ats = sort_appointments_created_at(offices)
    sort_offices = sort_office_appointments(appointments_created_ats)
    offices = sort_offices.flatten

    render json: offices,:include => {:appointments => {:only => [:meet_date, :meet_time, :called_status, :created_at]}, :staffs => {:only => [:id]}}, methods: [:image_url]
  end

private
  # オフィスごとの予約作成日を取得し、日付が新しい順にソート
  def sort_appointments_created_at(offices)
    array = []
    offices.each do |office|
      created_at = office.appointments.last.created_at
      array.push(created_at)
    end
    appointments_created_ats = array.sort {|a, b|
      a <=> b
    }.reverse
    return appointments_created_ats
  end

  # オフィスを、予約作成日が新しい順に配列に追加する
  def sort_office_appointments(appointments_created_ats)
    array = []
    appointments_created_ats.each do |appointments_created_at|
      appointments_array = Appointment.where(created_at: appointments_created_at)
      appointments_office_id = appointments_array.pluck(:office_id)
      array.push(Office.find(appointments_office_id))
    end
    return array
  end
end