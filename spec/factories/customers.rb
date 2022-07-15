FactoryBot.define do
  factory :customer do
    name                  { Faker::Name.name }
    sequence(:email)      { |n| "customer#{n}@example.com" }
    password              { 'password' }
    password_confirmation { 'password' }
    phone_number          { Faker::PhoneNumber.cell_phone }
    post_code             { Faker::Address.postcode }
    address               { 'sample address' }
    user_type             { 0 }
  end
end
