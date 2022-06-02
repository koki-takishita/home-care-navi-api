class ContactMailer < ApplicationMailer
  def send_message(contact)
    @contact = contact
    mail to: "email@example.com",
    subject: 'ホームケアナビ利用者からのお問い合わせが届きました'
  end
end
