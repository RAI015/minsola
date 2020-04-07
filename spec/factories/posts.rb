# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  caption       :text(65535)      not null
#  expectation   :string(255)      not null
#  feeling       :string(255)      not null
#  image         :string(255)
#  weather       :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  city_id       :bigint           not null
#  prefecture_id :bigint           not null
#  user_id       :bigint
#
# Indexes
#
#  index_posts_on_city_id        (city_id)
#  index_posts_on_prefecture_id  (prefecture_id)
#  index_posts_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (city_id => cities.id)
#  fk_rails_...  (prefecture_id => prefectures.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :post do
    caption { 'キャプションです。' }
    user
    created_at { Faker::Time.between(from: DateTime.now - 2, to: DateTime.now) }
  end
end
