class ContactsController < ApplicationController
    def index
        @contact = Contact.new
      end

      def confirm
        @contact = Contact.new(contact_params)
        if @contact.valid?
          render :action => 'confirm'
        else
          render :action => 'index'
        end
      end

      def success
        @contact = Contact.new(contact_params)
        if params[:back]
          render :action => 'index'
        else
          ContactMailer.send_mail(@contact).deliver_now
          render :action => 'success'
        end
      end

      private
        def contact_params
          params.require(:contact).permit(:name, :email, :types, :content)
        end
  end
