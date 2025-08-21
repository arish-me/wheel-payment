FactoryBot.define do
  factory :dispute do
    milestone { nil }
    raised_by { nil }
    reason { "MyText" }
    status { 1 }
  end
end
