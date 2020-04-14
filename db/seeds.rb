Faker::Config.locale = :ja

# 都道府県マスタ、市区町村マスタの生成
# CSVファイルを使用することを明示
require 'csv'

# 使用するデータ（CSVファイルの列）を指定
CSVROW_PREFID = 1
CSVROW_PREFNAME = 2
CSVROW_CITYNAME = 3

# CSVファイルを読み込み、DB（テーブル）へ保存
CSV.foreach('db/csv/prefectures_cities.csv') do |row|
  prefecture_id = row[CSVROW_PREFID]
  prefecture_name = row[CSVROW_PREFNAME]
  city_name = row[CSVROW_CITYNAME]

  Prefecture.find_or_create_by(name: prefecture_name)
  City.find_or_create_by(name: city_name, prefecture_id: prefecture_id)
end

# ゲストユーザー作成
User.create!(name:  "Guest User",
            email: "guest@example.com",
            password:              "12345678",
            password_confirmation: "12345678",
            confirmed_at: Time.zone.now,
            confirmation_sent_at: Time.zone.now,
            guest: true)

# ユーザー作成
1.upto(49) do |i|
  name  = Faker::Name.name
  email = "sample-#{i}@example.com"
  password = "password"
  User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              confirmed_at: Time.zone.now,
              confirmation_sent_at: Time.zone.now)
end

# ユーザーAvatar生成
users = User.order(:created_at).take(10)
users.each_with_index do |user, i|
  user.avatar = open("#{Rails.root}/db/fixtures/avatar/avatar-#{i + 1}.jpg")
  user.save
end

# Post作成
# weathers = %w[快晴 晴れ 薄曇り 曇り 雨 豪雨 雷 みぞれ 雪 大雪 あられ ひょう 霧 霧雨 砂あらし]
# feelings = %w[うだる暑さ 暑い 暖かい ちょうどいい 肌寒い 凍えるほど寒い あてはまらない]
# expectations = %w[今と変化なさそう 回復しそう 下り坂になりそう]
i = 0

users.each do
  1.upto(8) do |j|
    # Cityマスタからランダムに1件返す
    cities = City.where('id >= ?', rand(City.first.id..City.last.id)).first

    j = ((i * 8) + j)
    image = open("#{Rails.root}/db/fixtures/sola/sola-#{j}.jpg")
    caption = Faker::TvShows::BojackHorseman.quote
    weather = ApplicationHelper::WEATHERS.sample
    feeling = ApplicationHelper::FEELINGS.sample
    expectation = ApplicationHelper::EXPECTATIONS.sample
    prefecture_id = cities.prefecture_id
    city_id = cities.id

    users[i].posts.create!(
      image: image,
      caption: caption,
      weather: weather,
      feeling: feeling,
      expectation: expectation,
      prefecture_id: prefecture_id,
      city_id: city_id,
      created_at: i.zero? ? Time.zone.now : rand(Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day)
    )
  end
  i += 1
end

# お気に入りデータ作成
users = User.order(:id).take(8)
posts = Post.order(:id).take(15)
users.each do |user|
  posts.each do |post|
    user.like(post) unless user.id == post.user_id
  end
end

# ユーザープロフィール文
CSV.foreach('db/csv/profile.csv') do |row|
  user_id = row[0]
  profile = row[1]

  User.where(id: user_id).update(profile: profile)
end

# 記事のキャプション
CSV.foreach('db/csv/caption2.csv') do |row|
  post_id = row[0]
  caption = row[1]

  Post.where(id: post_id).update(caption: caption)
end

# コメント
CSV.foreach('db/csv/comment2.csv') do |row|
  user_id = row[0]
  post_id = row[1]
  comment = row[2]

  Comment.create!(user_id: user_id, post_id: post_id, comment: comment)
end

# リレーションシップ
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# 管理ユーザー作成
admin = User.create!(name:  "Admin User",
  email: "admin@example.com",
  password:              "12345678",
  password_confirmation: "12345678",
  confirmed_at: Time.zone.now,
  confirmation_sent_at: Time.zone.now,
  admin: true)

admin.avatar = open("#{Rails.root}/db/fixtures/avatar/Admin.png")
admin.profile = 'このアカウントは管理者アカウントです。'
admin.save


# i = 0
# 50.times do
#   i += 1
#   title = Faker::Address.state + 'の天気'
#   body = Faker::Lorem.paragraph_by_chars
#   image = open("#{Rails.root}/db/fixtures/sola/sola-#{i}.jpg")
#   users.each { |user| user.posts.create!(title: title, body: body, image: image) }
# end

# wheathers %w['快晴' '晴れ' '薄曇り' '曇り' '煙霧' '砂じんあらし' '地ふぶき' '霧' '霧雨' '雨' 'みぞれ' '雪' 'あられ' 'ひょう' '雷']
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