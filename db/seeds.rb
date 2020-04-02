Faker::Config.locale = :ja

# ゲストユーザー作成
User.create!(name:  "Guest User",
             email: "guest@example.com",
             password:              "12345678",
             password_confirmation: "12345678",
             confirmed_at: Time.zone.now,
             confirmation_sent_at: Time.zone.now)

1.upto(99) do |n|
  name  = Faker::Name.name
  email = "sample-#{n}@example.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               confirmed_at: Time.zone.now,
               confirmation_sent_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  title = Faker::Address.state + 'の天気'
  body = Faker::Lorem.paragraph_by_chars
  users.each { |user| user.posts.create!(title: title, body: body) }
end

# users = User.order(:created_at).take(9)

# users.each_with_index do |user, n|
#   user.avatar = open("#{Rails.root}/db/fixtures/avatar-#{n}.jpg")
#   user.save
# end