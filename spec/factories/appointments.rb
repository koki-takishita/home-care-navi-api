FactoryBot.define do
  factory :appointment do
    meet_date     { Time.parse("2023/01/01") }
    name          { Faker::Name.name }
    age           { rand(60..120) }
    phone_number  { Faker::PhoneNumber.cell_phone }
    comment       { 'お困りごと' }
    called_status { 0 }
    association :user, factory: :customer
    association :office
  end
end