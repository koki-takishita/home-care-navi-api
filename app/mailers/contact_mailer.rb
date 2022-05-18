class ContactMailer < ApplicationMailer
    default from: 'taker@example.com'
    default to: 'giver@example.com'
    layout 'mailer'

    def send_mail(contact)
      @contact = contact
      mail(from: contact.email, to: ENV['MAIL_ADDRESS'], subject: 'Webサイトより問い合わせが届きました') do |format|
        format.text
      end
    end
  end
