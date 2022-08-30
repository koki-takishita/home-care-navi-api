FactoryBot.define do
  factory :office_detail do
    detail { '広々とした空間と安全な最新設備をご用意いたしました。' }
    service_type { '介護付きホーム' }
    open_date { Time.zone.today }
    rooms { rand(0..100) }
    requirement { '満60歳以上の方' }
    facility { 'エントランス、個室、大浴場' }
    management { Faker::Company.name }
    link   { Faker::Internet.url }
    images { [Rack::Test::UploadedFile.new('spec/fixtures/island.png')] * 2 }
    comment_1 { '特徴画像1のコメント' }
    comment_2 { '特徴画像2のコメント' }

    association :office
  end
end
