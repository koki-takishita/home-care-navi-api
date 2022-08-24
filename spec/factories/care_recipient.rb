FactoryBot.define do
  factory :care_recipient do
    name { '田中 太郎' }
    kana { 'たなか たろう' }    
    age { 100 }
    post_code { Faker::Address.postcode } 
    address   { 'sample address' }
    family   { 'sample family' }
    association :office
    association :staff
  end
end