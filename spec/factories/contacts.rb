FactoryBot.define do
  factory :contact do
    name  { Faker::Name.name }
    email { 'contact@example.com' }
    types { 'ユーザー' }
    content { 'サイト利用者よりお問い合わせをします。' }
  end
end
