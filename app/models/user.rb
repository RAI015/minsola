# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)      not null
#  profile                :text(65535)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable #, :confirmable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # お気に入り機能用中間テーブル
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  # 自分がフォローしているユーザーとの関連
  has_many :active_relationships, class_name: 'Relationship', foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  # 自分がフォローされるユーザーとの関連
  has_many :passive_relationships, class_name: 'Relationship', foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following

  mount_uploader :avatar, AvatarUploader
  validates :name, presence: true, length: { maximum: 10 }

  # お気に入り追加
  def like(post)
    likes.find_or_create_by(post_id: post.id)
  end

  # お気に入り削除
  def unlike(post)
    likes.find_by(post_id: post.id).destroy
  end

  # お気に入り登録判定
  def like?(post)
    like_posts.include?(post)
  end

  # ユーザーをフォローする
  def follow(other_user)
    followings << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # フォローしているか判定
  def followed_by?(user)
    passive_relationships.find_by(following_id: user.id).present?
  end

end
