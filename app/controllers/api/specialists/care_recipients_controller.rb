class Api::Specialists::CareRecipientsController < ApplicationController
  def create
    care_recipient = CareRecipient.new(care_recipient_params)
    if care_recipient.valid?
      care_recipient.save!
    else
      render json: { status: care_recipient.errors.full_messages }
    end
  end

  private
  def care_recipient_params
    params.permit(:office_id, :name, :kana, :staff_id)
  end
end
