require 'csv'

def data_init
  @email_hash      = []
  @fax_number_hash = []
  @post_code_hash  = []
  @address_hash    = []
end

def set_data
  data_init
  CSV.foreach('db/dummy_files/dummy.csv', headers: true) do |row|
    @email_hash      << row['email']
    @fax_number_hash << row['phone_number']
    @post_code_hash  << row['post_code']
    @address_hash    << row['address']
  end
end

def progressbar(total: nil)
  @progressbar = ProgressBar.create(format: '%a |%b>>%i| %p%% %t',
                                    starting_at: 0,
                                    total: total,
                                    length: 80)
end

def create_customer(count: 100)
  User.customer.destroy_all
  progressbar(total: count)
  count.times do |n|
    c = Customer.create!(
      name: Faker::Name.name,
      phone_number: "#{rand(10..9999)}-#{rand(10..9999)}-#{rand(1000..9999)}",
      post_code: @post_code_hash[n],
      address: @address_hash[n],
      email: @email_hash[n],
      password: 'password',
      password_confirmation: 'password'
    )
    c.confirm
    @progressbar.increment
  end
end

set_data
create_customer
