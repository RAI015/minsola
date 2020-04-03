# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  image      :string(255)
#  title      :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { FactoryBot.create(:post) }

  it 'タイトル、本文、ユーザーがある場合、有効であること' do
    user = FactoryBot.create(:user)
    post = Post.new(
      title: 'タイトル',
      body: '本文',
      user: user
    )
    expect(post).to be_valid
  end

  describe '存在性の検証' do
    it 'タイトルがない場合、無効であること' do
      post.title = ''
      post.valid?
      expect(post).to_not be_valid
    end

    it 'メールアドレスがない場合、無効であること' do
      post.body = ''
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
    it 'タイトルが30文字以内の場合、有効であること' do
      post.title = 'a' * 30
      expect(post).to be_valid
    end

    it 'タイトルが31文字以上の場合、登録できないこと' do
      post.title = 'a' * 31
      expect(post).to_not be_valid
    end

    it '本文が500文字以内の場合、有効であること' do
      post.body = 'a' * 500
      expect(post).to be_valid
    end

    it '本文が501文字以上の場合、登録できないこと' do
      post.body = 'a' * 501
      expect(post).to_not be_valid
    end
  end
end
