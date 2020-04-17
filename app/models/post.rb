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
  mount_uploader :image, ImageUploader
  belongs_to :user
  has_many :comments, dependent: :destroy
  belongs_to :prefecture
  belongs_to :city
  # お気に入り機能用中間テーブル
  has_many :likes, dependent: :destroy

  default_scope -> { order(created_at: :DESC) }

  validates :caption, presence: true, length: { maximum: 300 }
  validates :image, presence: true
  validate :image_size
  validates :weather, presence: true
  validates :feeling, presence: true
  validates :expectation, presence: true

  # お気に入りされているか判定
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  # 検索機能
  scope :search, ->(search_params) do
    return if search_params.blank?

    caption_like(search_params[:caption])
      .prefecture_id_is(search_params[:prefecture_id])
      .city_id_is(search_params[:city_id])
      .weather_is(search_params[:weather])
  end
  # captionが存在する場合、captionをlike検索する
  scope :caption_like, ->(caption) { where('caption LIKE ?', "%#{caption}%") if caption.present? }
  # prefecture_idが存在する場合、prefecture_idで検索する
  scope :prefecture_id_is, ->(prefecture_id) { where(prefecture_id: prefecture_id) if prefecture_id.present? }
  # city_idが存在する場合、city_idで検索する
  scope :city_id_is, ->(city_id) { where(city_id: city_id) if city_id.present? }
  # weatherが存在する場合、weatherで検索する
  scope :weather_is, ->(weather) { where(weather: weather) if weather.present? }

  private

  def image_size
    errors.add(:image, 'ファイルサイズを5MB以下にしてください') if image.size > 5.megabytes
  end
end
