FactoryBot.define do
  factory :project do
    title { "MyString" }
    description { "MyText" }
    client { nil }
    developer { nil }
    status { 1 }
  end
end
