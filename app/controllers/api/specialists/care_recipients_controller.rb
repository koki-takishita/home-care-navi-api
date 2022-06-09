class Api::Specialists::CareRecipientsController < ApplicationController
  before_action :authenticate_specialist!
  
  def create
    care_recipient = current_specialist.office.care_recipients.build(care_recipient_params)
    if care_recipient.valid?
      care_recipient.save!
      render json: { status: 'success' }
    else
      render json: { status: care_recipient.errors.full_messages }
    end
  end

  private
  def care_recipient_params
    params.permit(:office_id, :name, :kana, :age, :post_code, :address, :staff_id, :family)
  end
end
