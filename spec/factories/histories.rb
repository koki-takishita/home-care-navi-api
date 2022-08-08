FactoryBot.define do
  factory :history do
    association :office
    association :user, factory: :customer
  end
end