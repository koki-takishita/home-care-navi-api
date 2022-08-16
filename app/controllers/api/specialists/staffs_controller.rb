class Api::Specialists::StaffsController < ApplicationController
  before_action :set_staff, only: %i[show update destroy]
  before_action :authenticate_specialist!

  def index
    @order_staffs = current_specialist.office.staffs.order(updated_at: :desc)
    @data_length = @order_staffs.count
    @staffs = if params[:page].blank?
                @order_staffs
              else
                @staffs = @order_staffs.limit(10).offset(params[:page].to_i * 10)
                render json: { staffs: @staffs, data_length: @data_length }, methods: [:image_url]
              end
  end

  def show
    render json: @staff, methods: [:image_url]
  end

  def create
    @staff = current_specialist.office.staffs.build(staff_params)
    if @staff.valid?
      @staff.save!
      render status: :ok, json: { message: 'スタッフを登録しました' }
    else
      render status: :unauthorized, json: { errors: @staff.errors.full_messages }
    end
  end

  def update
    if @staff.valid?
      @staff.update(staff_params)
      render status: :ok, json: { message: 'スタッフを更新しました' }
    else
      render status: :unauthorized, json: { errors: @staff.errors.full_messages }
    end
  end

  def destroy
    if @staff.valid?
      @staff.destroy
      render status: :ok, json: { message: 'スタッフを削除しました' }
    else
      render status: :unauthorized, json: { errors: @staff.errors.full_messages }
    end
  end

  private

    def staff_params
      params.permit(:office_id, :name, :kana, :introduction, :image)
    end

    def set_staff
      @staff = current_specialist.office.staffs.find(params[:id])
    end
end
