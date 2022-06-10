# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# tables = ["User", "Office", "Staff", "Contact"]
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