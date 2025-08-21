FactoryBot.define do
  factory :transaction do
    milestone { nil }
    payment_provider { "MyString" }
    provider_id { "MyString" }
    status { 1 }
    fee_cents { 1 }
    net_amount_cents { 1 }
  end
end
