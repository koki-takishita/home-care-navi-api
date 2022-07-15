class Api::Specialists::CareRecipientsController < ApplicationController
  before_action :authenticate_specialist!
  before_action :set_care_recipient, only: [:show, :update, :destroy]

  def index
    @order_care_recipients = current_specialist.office.care_recipients.order(updated_at: :desc)
    @data_length = @order_care_recipients.count
    @care_recipients = @order_care_recipients.limit(10).offset(params[:page].to_i * 10)
    render json: { care_recipients: @care_recipients.as_json(:include => [:staff], methods: [:image_url]), data_length: @data_length}
  end

  def show
    render json: @care_recipient, methods: [:image_url]
  end

  def create
    care_recipient = current_specialist.office.care_recipients.build(care_recipient_params)
    if care_recipient.valid?
      care_recipient.save!
      render json: { status: 'success' }
    else
      render json: { status: care_recipient.errors.full_messages }
    end
  end

  def create
    @care_recipient = CareRecipient.new(care_recipient_params)
    if @care_recipient.valid?
      @care_recipient.save!
    else
      render json: { status: @care_recipient.errors.full_messages }
    end
  end

  def update
    if @care_recipient.valid?
      @care_recipient.update(care_recipient_params)
      render json: { status: 'success' }
    else
    render json: { status: @care_recipient.errors.full_messages }
    end
  end

  def destroy
    if @care_recipient.valid?
      @care_recipient.destroy
      render json: { status: 'success' }
    else
      render json: { status: @care_recipient.errors.full_messages }
    end
  end

  private
  def care_recipient_params
    params.permit(:office_id, :name, :kana, :age, :post_code, :address, :staff_id, :family,  :image)
  end

  def set_care_recipient
    @care_recipient = current_specialist.office.care_recipients.find(params[:id])
    @office = current_specialist.office.id
  end
end
