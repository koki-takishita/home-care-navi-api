module Api
  class ContactsController < ApplicationController
    def create
    render json: {
      contacts = contacts.new(contacts_params)
    }
    end
  end
end

