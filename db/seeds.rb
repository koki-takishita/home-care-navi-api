# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
=begin
Office.create(name: 'ホームケアナビ佐渡1ホームケアナビ佐渡1', title: '事業所タイトル1事業所タイトル1', flags: '9', business_day_detail:'営業日の説明が入ります営業日の説明が入ります', address:'東京都中央区入船3-9-1第二細矢ビル1階', post_code:'001-0001', phone_number:'0001-01-0001', fax_number:'096-273-8765', user_id:'1', )
Office.create(name: 'ホームケアナビ佐渡2ホームケアナビ佐渡2', title: '事業所タイトル2事業所タイトル2', flags: '8', business_day_detail:'営業日の説明が入ります営業日の説明が入ります', address:'東京都中央区新川2-27-3', post_code:'002-0002', phone_number:'0002-02-0002', fax_number:'090-145-5678', user_id:'2', )
Office.create(name: 'ホームケアナビ佐渡3ホームケアナビ佐渡3', title: '事業所タイトル3事業所タイトル3', flags: '96', business_day_detail:'営業日の説明が入ります営業日の説明が入ります', address:'東京都中央区明石町1-6', post_code:'003-0003', phone_number:'0003-03-0003', fax_number:'050-687-2915', user_id:'3', )

10.times do |n|
  staff = Staff.create!(
  office_id: '1',
  name: "スタッフ#{n+1}",
  kana: "すたっふ",
  introduction: "スタッフ#{n+1}の紹介文です",
 )
 staff.image.attach(io: File.open(Rails.root.join('public/images/youngman_27.png')),
filename: 'youngman_27.png')
end
=end

puts "テーブル全削除処理スタート"
exclusion_tables = [
  'active_storage_variant_records',
  'active_storage_blobs',
  'active_storage_attachments',
  'schema_migrations',
  'ar_internal_metadata'
]
all_tables = ActiveRecord::Base.connection.tables
tables = all_tables.difference(exclusion_tables)
tables.each{|table|
  table.classify.constantize.destroy_all
}
flag = false
tables.each {|table|
  if table.classify.constantize.exists?
    puts "#{table}テーブルが削除できてない"
    flag = true
  end
}
puts !flag ? "テーブル全削除完了" : "Destroy Error 削除できてないテーブルがあります"

2.times{|n|
  User.create!(
    email:                 "customer#{n}@example.com",
    password:              'password',
    password_confirmation: 'password',
    name:                  "customer#{n}",
    phone_number:          "000-0000-000#{n}",
    post_code:             '000-0000',
    address:               '東京都千代田区丸の内1-1-1',)}
user = User.first
user.confirm
if(User.count == 2)
  puts ""
  puts "Userサンプルデータ作成完了"
  puts "---------------------------------"
  User.all.each{|user|
    puts "email       #{user.email}"
    puts "password    password"
    puts "user_type   #{user.user_type}"
    puts "有効化済み? #{user.confirmed?}"
    puts "---------------------------------"
  }
else
  puts "User作成失敗"
end

30.times{|n|
  Specialist.create!(
    email:                 "specialist#{n + 3}@example.com",
    password:              'password',
    password_confirmation: 'password',
    name:                  "specialist#{n}",
    phone_number:          "000-0000-000#{n + 3}",
    post_code:             '000-0000',
    address:               '東京都千代田区丸の内1-1-1',)}
specialist = Specialist.third
specialist2 = Specialist.last
specialist.confirm
specialist2.confirm
Specialist.all.offset(2).each{|s| s.confirm}
if(Specialist.all.offset(2).count == 30)
  puts ""
  puts "Specialistサンプルデータ作成完了"
  puts "---------------------------------"
  Specialist.all.offset(2).each{|user|
    user.specialist!
    puts "email       #{user.email}"
    puts "password    password"
    puts "user_type   #{user.user_type}"
    puts "有効化済み? #{user.confirmed?}"
    puts "---------------------------------"
  }
else
  puts "スペシャリスト作成失敗"
end

# 県の情報
# 市の情報
# 市町村の情報
# 番地

address = [
  "東京都目黒区",
  "東京都渋谷区宇田川町３６−６ ワールド宇田川ビル ５階B室",
  "静岡県浜松市南区遠州浜２丁目１１番地３９号",
  "新潟県佐渡市秋津４１７ー９",
  "東京都中央区",
  "東京都港区",
  "東京都新宿区",
  "東京都文京区",
  "東京都台東区",
  "東京都墨田区",
  "東京都江東区",
  "東京都品川区",
  "東京都目黒区",
  "東京都渋谷区宇田川町３６−６ ワールド宇田川ビル ５階B室",
  "静岡県浜松市南区遠州浜２丁目１１番地３９号",
  "新潟県佐渡市秋津４１７ー９",
  "東京都中央区",
  "東京都港区",
  "東京都新宿区",
  "東京都文京区",
  "東京都台東区",
  "東京都墨田区",
  "東京都江東区",
  "東京都品川区",
  "東京都目黒区",
  "東京都渋谷区宇田川町３６−６ ワールド宇田川ビル ５階B室",
  "静岡県浜松市南区遠州浜２丁目１１番地３９号",
  "新潟県佐渡市秋津４１７ー９",
  "東京都中央区",
  "東京都港区",
  "東京都新宿区",
  "東京都文京区",
  "東京都台東区",
  "東京都墨田区",
  "東京都江東区",
  "東京都品川区"
]
Specialist.all.offset(3).each_with_index {|s, i|
  s.create_office!(
    name:                'サンプルオフィス',
    title:               'サンプルタイトル',
    flags:               65,
    address:             address[i],
    post_code:           '111-1111',
    phone_number:        "111-1111-111#{i}",
    fax_number:          '111-1111-1111',
    business_day_detail: '営業日の説明が入ります')
}
office = Office.first
10.times {|n|
  office.staffs.create(
    name:         "サンプルスタッフ#{n}",
    kana:         "さんぷるすたっふ",
    introduction: "サンプルスタッフ#{n}の紹介文")
}
staffs = office.staffs
if(staffs)
  puts ""
  puts "Staffsサンプルデータ作成完了"
  puts "---------------------------------"
  puts "作成したスタッフ数 #{staffs.count}"
  puts "---------------------------------"
end

office_detail = office.create_office_detail!(
  detail:       'オフィスの詳細です。オフィスの詳細です。オフィスの詳細です。',
  service_type: 'サービスタイプです。サービスタイプです。サービスタイプです。',
  rooms:        10,
  requirement:  '要件です。要件です。要件です。要件です。',
  facility:     '施設です。施設です。施設です。施設です。',
  management:   '管理です。管理です。管理です。管理です。',
  link:         'https://prum.jp/',
  open_date:    Time.now)
office_detail = office.office_detail
if(office_detail)
  puts ""
  puts "Office_detailサンプルデータ作成完了"
  puts "---------------------------------"
  puts "detail       #{office_detail.detail}"
  puts "service_type #{office_detail.service_type}"
  puts "rooms        #{office_detail.rooms}"
  puts "requirement  #{office_detail.requirement}"
  puts "facility     #{office_detail.facility}"
  puts "management   #{office_detail.management}"
  puts "link         #{office_detail.link}"
  puts "open_date    #{office_detail.open_date}"
  puts "---------------------------------"
end

# 顧客がお礼を作成
office    = Office.first
office_id = office.id
customer  = User.first
2.times {|n|
  staff     = office.staffs.offset(n).sample
  staff_id  = staff.id
  customer.thanks.create!(
    staff_id:  staff_id,
    office_id: office_id,
    comments:  "#{n}ありがとう。ありがとう。ありがとう。"
  )
}
thanks = office.thanks
thanks.each{|tnk|
  if(tnk)
    puts ""
    puts "thanksサンプルデータ作成完了"
    puts "---------------------------------"
    puts "作成したお礼        #{tnk.comments}"
    puts "お礼されたスタッフ  #{tnk.staff.name}"
    puts "お礼されたオフィス  #{tnk.office.name}"
    puts "---------------------------------"
  end
}
# tables = ["User", "Office", "Staff", "Contact"]
=begin
puts "テーブル全削除処理スタート"
User.destroy_all
Office.destroy_all
Staff.destroy_all
Contact.destroy_all
puts "テーブル全削除完了"

User.create!(
  name:                     'カスタマー',
  password:                 'password',
  password_confirmation:    'password',
  phone_number:             '000-0000-0000',
  post_code:                '111-1111',
  email:                    'customer@example.com',
  address:                  'カスタマ県カスタマ市カスタマ町 1-1-1',
  user_type:                'customer'
)
user = User.first
user.confirm
if(user)
  puts ""
  puts "Userサンプルデータ作成完了"
  puts "---------------------------------"
  puts "email       #{user.email}"
  puts "password    password"
  puts "user_type   #{user.user_type}"
  puts "有効化済み? #{user.confirmed?}"
  puts "---------------------------------"
end

User.create!(
  name:                     'カスタマー',
  password:                 'password',
  password_confirmation:    'password',
  phone_number:             '000-0000-0001',
  post_code:                '111-1111',
  email:                    'customer2@example.com',
  address:                  'カスタマ県カスタマ市カスタマ町 1-1-2',
  user_type:                'customer'
)
user2 = User.second
if(user)
  puts ""
  puts "Userサンプルデータ作成完了"
  puts "---------------------------------"
  puts "email       #{user2.email}"
  puts "password    password"
  puts "user_type   #{user2.user_type}"
  puts "有効化済み? #{user2.confirmed?}"
  puts "---------------------------------"
end


Specialist.create!(
  name:                     'スペシャリスト',
  password:                 'password',
  password_confirmation:    'password',
  phone_number:             '000-0000-1111',
  post_code:                '111-1111',
  email:                    'specialist@example.com',
  address:                  'スペシャリスト県スペシャリスト市スペシャリスト町 1-1-1',
  user_type:                'specialist'
)

specialist = Specialist.third
specialist.specialist!
specialist.confirm
if(specialist)
  puts ""
  puts "Specialistサンプルデータ作成完了"
  puts "---------------------------------"
  puts "email       #{specialist.email}"
  puts "password    password"
  puts "user_type   #{specialist.user_type}"
  puts "有効化済み? #{specialist.confirmed?}"
  puts "---------------------------------"
end

specialist.create_office!(
  name:                'サンプルオフィス',
  title:               'サンプルタイトル',
  flags:               65,
  address:             'サンプル県サンプル市サンプル町 1-1-1',
  post_code:           '111-1111',
  phone_number:        '111-1111-1111',
  fax_number:          '111-1111-1111',
  business_day_detail: '営業日の説明が入ります',
)
office = specialist.office
if(office)
  puts ""
  puts "Officeサンプルデータ作成完了"
  puts "---------------------------------"
  puts "name #{office.name}"
  puts "休日   #{office.selected_flags}"
  puts "---------------------------------"
end

10.times {|n|
  office.staffs.create!(
    name:         "サンプルスタッフ#{n}",
    kana:         "さんぷるすたっふ１",
    introduction: "サンプルスタッフ#{n}の紹介文",
  )
}
staffs = office.staffs
if(staffs)
  puts ""
  puts "Staffsサンプルデータ作成完了"
  puts "---------------------------------"
  puts "作成したスタッフ数 #{staffs.count}"
  puts "---------------------------------"
end
=======
=end
