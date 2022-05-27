class Api::Specialists::StaffsController < ApplicationController
  def index
    staffs = Staff.all
    render json: staffs, methods: [:image_url]
  end

  def create
    staff = Staff.new(staff_params)
    if staff.valid?
      staff.save!
    else
      render json: { status: staff.errors.full_messages }
    end
  end

  private
    def staff_params
      params.permit(:office_id, :name, :kana, :introduction, :image)
    end
end
