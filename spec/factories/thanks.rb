FactoryBot.define do
  factory :thank do
    comments { 'ありがとう、素晴らしい対応でした' }    
    name { '老人' }
    age { 100 }
    association :user, factory: :customer
    association :office
    association :staff
  end
end
