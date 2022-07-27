require 'open-uri'
require "csv"

Rails.application.reloader.wrap do
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

  def dl_image
    retry_count = 0
    begin
      faker_image_path = Faker::Avatar.image
      image = URI.open(faker_image_path)
    rescue OpenURI::HTTPError => e
      puts "#{e.class} #{e.message}"
      puts e.backtrace
      retry_count += 1
      if retry_count <= 3
        retry
      else
        image = nil
      end
    end
    return image
  end

  def build_image
    Faker::Config.locale = :en
    image = dl_image
    Faker::Config.locale = :ja
    unless image.nil?
      ActionDispatch::Http::UploadedFile.new(tempfile: image, filename: 'avatar_image', type: image.content_type)
    else
      nil
    end
  end

  def create_care_recipients(office: nil, count: 50)
    office.care_recipients.destroy_all
    staffs    = office.staffs
    unless(staffs.count > 0)
      e = <<-TEXT
      staffが存在しません.
      最後まで実行したい場合1か2の指示に従ってください。
      1. rails db:seed:dummy_staffs
      2. id「#{office.id}」のofficeに紐付いているstaffを1人以上にする
      TEXT
      raise e
    end
    count.times{|n|
      name = Faker::Name.name
      image = build_image
      office.care_recipients.create!(
        name: name,
        kana: name.yomi,
				age: rand(60..120),
				post_code: @post_code_hash[n],
				address: @address_hash[n],
				family: "家族情報が入ります",
				staff_id: staffs.sample.id,
        image: image
      )
    }

	  if office.care_recipients.count === 50
		  puts "利用者の作成が完了しました"
		  puts "作成した利用者数 #{office.care_recipients.count}"
	  end
  end

  def create_office_care_recipients
    office = Specialist.first.office
		create_care_recipients(office: office)
  end
end

set_data
create_office_care_recipients