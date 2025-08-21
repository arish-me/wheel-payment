FactoryBot.define do
  factory :milestone do
    title { "MyString" }
    description { "MyText" }
    amount_cents { 1 }
    currency { "MyString" }
    status { 1 }
    project { nil }
  end
end
