FactoryBot.define do
  factory :post do
    title { 'タイトル' }
    body { '本文です。' }
    user
    created_at { Faker::Time.between(from: DateTime.now - 2, to: DateTime.now) }
  end
end
