class Api::Specialists::StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :update]

  def index
    staffs = Staff.all
    render json: staffs, methods: [:image_url]
  end

  def show
    render json: @staff
  end

  def create
    staff = Staff.new(staff_params)
    if staff.valid?
      staff.save!
    else
      render json: { status: staff.errors.full_messages }
    end
  end

  def update
    if @staff.valid?
      @staff.update(staff_params)
      render json: { status: 'success' }
    else
    render json: { status: staff.errors.full_messages }
    end
  end

  private
    def staff_params
      params.permit(:office_id, :name, :kana, :introduction, :image)
    end

    def set_staff
      @staff = Staff.find(params[:id])
    end
end
