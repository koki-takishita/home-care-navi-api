module Api
  class ContactsController < ApplicationController
    def create
      @contacts = Contact.new(contacts_params)

      if @contacts.valid?
        @contacts.save!
        render json: @contacts, status: :ok
        ContactMailer.send_message(@contacts).deliver_now
      else
        render json: { status: @contacts.errors.full_messages }
      end
    end

    private

      def contacts_params
        params.permit(:name, :email, :types, :content)
      end
  end
end
