=begin
require "csv"
CSV.foreach("db/dummy_files/dummy.csv", headers: true) do |row|
  #p row.headers
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
    post_code:             '0000000',
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
    phone_number:          "100-0000-000#{n + 3}",
    post_code:             '0000000',
    address:               '東京都千代田区丸の内1-1-1',)}
specialist = Specialist.third
specialist2 = Specialist.last
specialist.confirm
specialist2.confirm
Specialist.offset(2).each{|s| s.confirm}
if(Specialist.offset(2).count == 30)
  puts ""
  puts "Specialistサンプルデータ作成完了"
  puts "---------------------------------"
  Specialist.offset(2).each{|user|
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
    post_code:           "111111#{i}",
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
office    = User.third.office
office_id = office.id
customer  = User.first
from = Time.parse("2023/01/01")
to = Time.parse("2023/12/31")
20.times {|n|
  office.appointments.create!(
    office_id:     office_id,
    name:          "利用者#{n}",
    meet_date:     Random.rand(from..to),
    meet_time:     "18:00〜20:00",
    phone_number:  "000-00#{n}-0000",
    age:           Random.rand(60..120),
    user_id:       customer.id,
    comment:       "お困りごと#{n}",
    called_status: Random.rand(0..2)
  )
}
appointments = office.appointments
appointments.each{|appt|
  if(appt)
    puts ""
    puts "appointmentsサンプルデータ作成完了"
    puts "---------------------------------"
    puts "予約した事業所名  #{appt.office.name}"
    puts "利用者名         #{appt.name}"
    puts "連絡済み?        #{appt.called_status}"
    puts "---------------------------------"
  end
}

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
