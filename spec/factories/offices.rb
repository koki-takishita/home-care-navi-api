FactoryBot.define do
  factory :office do
    name  { Faker::Company.name }
    title { Faker::Game.title }
    flags { rand(1..127) }
    business_day_detail { '休日の説明です.' }
    address      { 'sample address' }
    post_code    { Faker::Address.postcode }
    phone_number { Faker::PhoneNumber.cell_phone }
    fax_number   { Faker::PhoneNumber.cell_phone }

    trait :with_specialist do
      association :user, factory: :specialist
    end

    trait :with_staffs do
      after(:create) do |office|
        create_list :staff, 2, office: office
      end
    end
  end
end
