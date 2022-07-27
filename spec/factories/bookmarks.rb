FactoryBot.define do
  factory :bookmark do
    association :office
    association :user, factory: :customer
  end
end