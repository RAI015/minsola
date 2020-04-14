# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  caption       :text(65535)      not null
#  expectation   :string(255)      not null
#  feeling       :string(255)      not null
#  image         :string(255)      not null
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
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  belongs_to :prefecture
  belongs_to :city

  # お気に入り機能用中間テーブル
  has_many :likes, foreign_key: 'post_id', dependent: :destroy
  # has_many :users, through: :likes

  mount_uploader :image, ImageUploader
  validates :caption, presence: true, length: { maximum: 300 }
  validates :image, presence: true
  validate :image_size
  validates :weather, presence: true
  validates :feeling, presence: true
  validates :expectation, presence: true

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  private

  def image_size
    errors.add(:image, 'ファイルサイズを5MB以下にしてください') if image.size > 5.megabytes
  end
end
