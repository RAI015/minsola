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
require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { FactoryBot.create(:post) }

  it 'タイトル、本文、ユーザーがある場合、有効であること' do
    user = FactoryBot.create(:user)
    post = Post.new(
      caption: 'キャプション',
      user: user
    )
    expect(post).to be_valid
  end

  describe '存在性の検証' do
    # it 'タイトルがない場合、無効であること' do
    #   post.title = ''
    #   post.valid?
    #   expect(post).to_not be_valid
    # end

    it 'キャプションがない場合、無効であること' do
      post.caption = ''
      post.valid?
      expect(post).to_not be_valid
    end

    it 'ユーザーがない場合、無効であること' do
      post.user = nil
      post.valid?
      expect(post).to_not be_valid
    end
  end

  describe '文字数の検証' do
    # it 'タイトルが30文字以内の場合、有効であること' do
    #   post.title = 'a' * 30
    #   expect(post).to be_valid
    # end

    # it 'タイトルが31文字以上の場合、登録できないこと' do
    #   post.title = 'a' * 31
    #   expect(post).to_not be_valid
    # end

    it 'キャプションが300文字以内の場合、有効であること' do
      post.caption = 'a' * 300
      expect(post).to be_valid
    end

    it 'キャプションが301文字以上の場合、登録できないこと' do
      post.caption = 'a' * 301
      expect(post).to_not be_valid
    end
  end
end
