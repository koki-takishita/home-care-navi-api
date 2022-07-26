def create_appointments(count: Customer.count, office: nil)
  customers = User.customer
  unless(customers.count > 0)
    e = <<-TEXT
    customerが存在しません。
    最後まで実行したい場合1か2の指示に従ってください。
    1. rails db:seed:dummy_customer
    2. customerを1人以上作成してください
    TEXT

    raise e
  end

  count.times{|n|
    from = Time.parse("2023/01/01")
    to = Time.parse("2023/12/31")
    timezone_from = Time.zone.parse('2010-01-01 00:00:00')
    timezone_to   = Time.zone.parse('2021-12-31 00:00:00')
    random_timezone = rand(timezone_from..timezone_to)

    customers[n].appointments.create!(
      meet_date:     rand(from..to),
      meet_time:     "18:00〜20:00",
      name:          Faker::Name.name,
      age:           rand(60..120),
      phone_number:  Faker::PhoneNumber.cell_phone,
      comment:       "お困りごと",
      called_status: rand(0..2),
      office_id:     office.id,
      created_at: random_timezone,
			updated_at: random_timezone
    )
  }
end

def set_progressbar(total: nil)
  @progressbar = ProgressBar.create(:format => '%a |%b>>%i| %p%% %t',
                                   :starting_at => 0,
                                   :total => total,
                                   :length => 80)
end

def create_customer_one_office_appointments
  Appointment.destroy_all
  office = Specialist.first.office
  create_appointments(office: office)
end

def create_customer_multiple_office_appointments
  offices = Office.eager_load(:staffs).with_attached_images.limit(10)
  set_progressbar(total: offices.count)
  offices.each{|office|
    create_appointments(office: office)
    @progressbar.increment
  }
end

create_customer_one_office_appointments
create_customer_multiple_office_appointments