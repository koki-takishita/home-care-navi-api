require 'open-uri'

FactoryBot.define do
  factory :staff do
    name { 'sample staff' }
    kana { 'さんぷる すたっふ' }
    introduction { "さんぷる すたふは素晴らしいスタッフです。" }
    image { nil }
    association :office
  end
end
