class ContactMailer < ApplicationMailer
  def send_message(name)
    @name = name
#    @email = @contact.email
    @greeting = "お問い合わせ内容を確認して、返信してください。"
    mail to: "master@example.com",
    subject: 'ホームケアナビ利用者からのお問い合わせが届きました'
  end
end


