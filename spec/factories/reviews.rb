FactoryBot.define do
  factory :review do
    milestone { nil }
    reviewer { nil }
    reviewed { nil }
    rating { 1 }
    comment { "MyText" }
  end
end
