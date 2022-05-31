module Api
  class ContactsController < ApplicationController
    def create
      @contacts = Contact.new(contacts_params)

      if @contacts.valid?
        @contacts.save!
      else
        render json: { status: @contacts.errors.full_messages }
      end
    end
#      contacts = params[:contacts].permit(:name, :email, :types, :content)
#      Contacts.create(contacts)

#  render json: {
#    test: "true"
#    }
private
  def contacts_params
    params.permit(:name, :email, :types, :content)
  end

  end
end

