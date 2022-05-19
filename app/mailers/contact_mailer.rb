  class ContactMailer < ApplicationMailer
    def contact_mail(contact)
      @contact = contact
      mail to: 'master@gmail.com', subject: 'お問い合わせありがとうございます'
    end
  end
