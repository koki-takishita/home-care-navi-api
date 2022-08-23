FactoryBot.define do
  factory :care_recipient do
    name { 'テスト' }
    kana { 'かな' }    
    age { 100 }
    post_code { Faker::Address.postcode } 
    address   { 'sample address' }
    family   { 'sample family' }
    association :office
    association :staff
  end
end