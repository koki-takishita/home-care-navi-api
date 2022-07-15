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
  Customer.create!(
    email:                 "customer#{n}@example.com",
    password:              'password',
    password_confirmation: 'password',
    name:                  "customer#{n}",
    phone_number:          "000-0000-000#{n}",
    post_code:             '0000000',
    address:               '東京都千代田区丸の内1-1-1',)}
if(Customer.count == 2)
  puts ""
  puts "カスタマーサンプルデータ作成完了"
  puts "---------------------------------"
  Customer.all.each{|user|
    user.confirm
    puts "email       #{user.email}"
    puts "password    password"
    puts "user_type   #{user.user_type}"
    puts "有効化済み? #{user.confirmed?}"
    puts "---------------------------------"
  }
else
  puts "カスタマー作成失敗"
end

30.times{|n|
  Specialist.create!(
    email:                 "specialist#{n + 3}@example.com",
    password:              'password',
    password_confirmation: 'password',
    name:                  "specialist#{n}",
    phone_number:          "100-0000-000#{n + 3}",
    post_code:             '0000000',
    address:               '東京都千代田区丸の内1-1-1',)}
if(Specialist.count == 30)
  puts ""
  puts "Specialistサンプルデータ作成完了"
  puts "---------------------------------"
  Specialist.all.each{|user|
    user.confirm
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
Specialist.all.each_with_index {|s, i|
  s.create_office!(
    name:                "サンプルオフィス-#{i}",
    title:               "サンプルタイトル-#{i}",
    flags:               "#{i}",
    address:             address[i],
    post_code:           "111111#{rand(1..9)}",
    phone_number:        "111-1111-112#{i}",
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

# 顧客が予約を作成
office = Specialist.first.office
office_id = office.id
from = Time.parse("2023/01/01")
to = Time.parse("2023/12/31")
timezone_from = Time.zone.parse('2010-01-01 00:00:00')
timezone_to   = Time.zone.parse('2021-12-31 00:00:00')
## 様々なユーザーが事業所に予約をする
20.times {|n|
  office.appointments.create!(
    office_id:     office_id,
    name:          "利用者#{n}",
    meet_date:     Random.rand(from..to),
    meet_time:     "18:00〜20:00",
    phone_number:  "000-00#{n}-0000",
    age:           Random.rand(60..120),
    user_id:       Random.rand(Customer.first.id..Customer.last.id),
    comment:       "お困りごと#{n}",
    called_status: Random.rand(0..2),
    created_at: rand(timezone_from..timezone_to)
  )
}
## 特定のユーザーが様々な事業所に予約をする
5.times {|n|
  office = Specialist.find(Random.rand(Specialist.first.id..Specialist.last.id)).office
  office_id = office.id
  office.appointments.create!(
    office_id:     office_id,
    name:          "利用者#{n}",
    meet_date:     Random.rand(from..to),
    meet_time:     "18:00〜20:00",
    phone_number:  "000-00#{n}-0000",
    age:           Random.rand(60..120),
    user_id:       Customer.first.id,
    comment:       "お困りごと#{n}",
    called_status: Random.rand(0..2),
    created_at: rand(timezone_from..timezone_to)
  )
}
if(Appointment.count == 25)
  puts ""
  puts ""
  puts "Appointmentsサンプルデータ作成完了"
  puts "---------------------------------"
  puts "作成した予約数 #{Appointment.count}"
  puts "---------------------------------"
else
  puts ""
  puts ""
  puts "Appointmentsサンプルデータ作成失敗"
  puts ""
  puts ""
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
=end
