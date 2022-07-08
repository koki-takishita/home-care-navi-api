require "csv"
CSV.foreach("db/dummy_files/dummy.csv", headers: true) do |row|
  first_name      = row['first_name']
  last_name       = row[0]
  first_name_kana = row['first_name_kana']
  last_name_kana  = row['last_name_kana']
  age             = row['age']
  birth_day       = row['birth_day']
  gender          = row['gender']
  blod            = row['blod']
  email           = row['email']
  tel_number      = row['tel_number']
  fax_number      = row['phone_number']
  post_code       = row['post_code']
  address         = row['address']
  company         = row['company']
  credit          = row['credit']
  credit_deadline = row['credit_deadline']
  my_number       = row['my_number']

  Office.create{|office|
		office.name  		    = company
		office.title 		    = "#{company}は最高のケアマネ事務所である理由"
		office.flags 		    = rand(1..127)
		office.address      = address
		office.post_code    = post_code
		office.phone_number = tel_number
		office.fax_number   = fax_number
		office.business_day_detail = "営業日に関する説明営業日に関する説明"
	}
end
