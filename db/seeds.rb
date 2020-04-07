Faker::Config.locale = :ja

# ゲストユーザー作成
User.create!(name:  "Guest User",
            email: "guest@example.com",
            password:              "12345678",
            password_confirmation: "12345678",
            confirmed_at: Time.zone.now,
            confirmation_sent_at: Time.zone.now)

1.upto(49) do |n|
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

users = User.order(:created_at).take(10)

users.each_with_index do |user, n|
  user.avatar = open("#{Rails.root}/db/fixtures/avatar/avatar-#{n + 1}.jpg")
  user.save
end

i = 0
users.each do
  1.upto(5) do |n|
    n = ((i * 5) + n) + 1
    title = Faker::Address.state + ' ' + Faker::Address.city + 'の天気'
    body = Faker::Lorem.paragraph_by_chars
    image = open("#{Rails.root}/db/fixtures/sola/sola-#{n}.jpg")
    users[i].posts.create!(
      title: title,
      body: body,
      image: image
    )
  end
  i += 1
end


# i = 0
# 50.times do
#   i += 1
#   title = Faker::Address.state + 'の天気'
#   body = Faker::Lorem.paragraph_by_chars
#   image = open("#{Rails.root}/db/fixtures/sola/sola-#{i}.jpg")
#   users.each { |user| user.posts.create!(title: title, body: body, image: image) }
# end

# 天気の種類
# （１）快晴
# （２）晴れ
# （３）薄曇り
# （４）曇り
# （５）煙霧
# （６）砂じんあらし
# （７）地ふぶき
# （８）霧
# （９）霧雨
# （１０）雨
# （１１）みぞれ
# （１２）雪
# （１３）あられ
# （１４）ひょう
# （１５）雷