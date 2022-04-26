FactoryBot.define do
  factory :user do
    name                  {"田中 太郎"}
    email                 {"sample@gmail.com"}
    password              {"1234567"}
    password_confirmation    {"1234567"}
    phone_number          {"11111111111"}
    post_code             {"1111111"}
    address               {"佐渡市秋津"}
  end
end
