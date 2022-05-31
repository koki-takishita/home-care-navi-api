module Api
  class ContactsController < ApplicationController
    def create
    render json: {
#     contacts = Contacts.new(contacts_params)
      contacts = params[:contacts].permit(:name, :email, :types, :content)
      Contacts.create(contacts)
    }

#  render json: {
#    test: "true"
#    }

    end
  end
end

