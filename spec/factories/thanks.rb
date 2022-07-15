FactoryBot.define do
  factory :thank do
    comments { 'ありがとう、素晴らしい対応でした' }    
    association :user, factory: :customer
    association :office
    association :staff
  end
end
