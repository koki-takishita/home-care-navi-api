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

    private
      def contacts_params
       params.permit(:name, :email, git :types, :content)
      end
    end
end
