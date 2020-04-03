FactoryBot.define do
  factory :comment do
    comment { 'コメント' }
    post
    user
    created_at { Faker::Time.between(from: DateTime.now - 2, to: DateTime.now) }
  end
end
