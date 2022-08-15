class ContactMailer < ApplicationMailer
  def send_message(contact)
    @contact = contact
    mail(to: @contact.email, subject: 'ホームケアナビ利用者からのお問い合わせが届きました')
  end
end
