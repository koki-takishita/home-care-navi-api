FactoryBot.define do
  factory :specialist do
    name                  { Faker::Name.name }
    sequence(:email)      { |n| "specialist#{n}@example.com" }
    password              { 'password' }
    password_confirmation { 'password' }
    phone_number          { Faker::PhoneNumber.cell_phone }
    post_code             { Faker::Address.postcode }
    address               { 'sample address' }
    user_type             { 1 }
  end
end
