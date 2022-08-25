FactoryBot.define do
  factory :staff do
    name { 'sample staff' }
    kana { 'さんぷる すたっふ' }
    introduction { 'さんぷる すたっふは素晴らしいスタッフです。' }
    image { nil }
    association :office
  end
end
