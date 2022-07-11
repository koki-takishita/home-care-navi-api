require "csv"

def data_init
  @email_hash      = []
  @tel_number_hash = []
  @fax_number_hash = []
  @post_code_hash  = []
  @address_hash    = []
end

def set_data
  data_init
  CSV.foreach("db/dummy_files/dummy.csv", headers: true) do |row|
    @email_hash      << row['email']
    @tel_number_hash << row['tel_number']
    @fax_number_hash << row['phone_number']
    @post_code_hash  << row['post_code']
    @address_hash    << row['address']
  end
end

def set_progressbar(total: nil)
  @progressbar = ProgressBar.create(:format => '%a |%b>>%i| %p%% %t',
                                   :starting_at => 0,
                                   :total => total,
                                   :length => 80) 
end

def create_customer(count: 10)
  User.customer.destroy_all
  set_progressbar(total: count)
  count.times{|n|
    c = Customer.create!(
          name:         Faker::Name.name,
          phone_number: @tel_number_hash[n],
          post_code:    @post_code_hash[n],
          address:      @address_hash[n],
          email:        @email_hash[n],
          password:              'password',
          password_confirmation: 'password')
    c.confirm
    @progressbar.increment
  } 
end

set_data
create_customer
