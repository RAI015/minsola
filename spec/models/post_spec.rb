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

  it '有効なファクトリを持つこと' do
    expect(post).to be_valid
  end

  it 'キャプション、画像、ユーザー、都道府県、市区町村、天気、体感、予想がある場合、有効であること' do
    user = FactoryBot.create(:user)
    prefecture = FactoryBot.create(:prefecture)
    city = FactoryBot.create(:city)
    post = Post.new(
      caption: '今日は快晴です。',
      image: Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/rspec_test.jpg')),
      user: user,
      prefecture: prefecture,
      city: city,
      weather: '快晴',
      feeling: 'ちょうどいい',
      expectation: '今と変化なさそう'
    )
    expect(post).to be_valid
  end

  describe '存在性の検証' do
    it 'キャプションがない場合、無効であること' do
      post.caption = ''
      post.valid?
      expect(post).to_not be_valid
    end
    it '画像がない場合、無効であること' do
      post.image = nil
      post.valid?
      expect(post).to_not be_valid
    end
    it 'ユーザーがない場合、無効であること' do
      post.user = nil
      post.valid?
      expect(post).to_not be_valid
    end
    it '都道府県がない場合、無効であること' do
      post.prefecture = nil
      post.valid?
      expect(post).to_not be_valid
    end
    it '市区町村がない場合、無効であること' do
      post.city = nil
      post.valid?
      expect(post).to_not be_valid
    end
    it '天気がない場合、無効であること' do
      post.weather = ''
      post.valid?
      expect(post).to_not be_valid
    end
    it '体感がない場合、無効であること' do
      post.feeling = ''
      post.valid?
      expect(post).to_not be_valid
    end
    it '予想がない場合、無効であること' do
      post.expectation = ''
      post.valid?
      expect(post).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it 'キャプションが300文字以内の場合、有効であること' do
      post.caption = 'a' * 300
      expect(post).to be_valid
    end
    it 'キャプションが301文字以上の場合、無効であること' do
      post.caption = 'a' * 301
      expect(post).to_not be_valid
    end
  end

  describe 'メソッド' do
    it '投稿をいいね/いいね解除できること' do
      alice = FactoryBot.create(:user)
      bob = FactoryBot.create(:user, :with_posts, posts_count: 1)
      expect(bob.posts.first.liked_by?(alice)).to eq false
      alice.like(bob.posts.first)
      expect(bob.posts.first.liked_by?(alice)).to eq true
      alice.unlike(bob.posts.first)
      expect(bob.posts.first.liked_by?(alice)).to eq false
    end
  end

  describe '#search' do
    # 各テストの前にPostを作成
    before do
      user = FactoryBot.create(:user)
      prefecture = FactoryBot.create(:prefecture, name: '神奈川県')
      @city = FactoryBot.create(:city, name: '横須賀市', prefecture: prefecture)
      @post = FactoryBot.create(
        :post,
        user: user,
        caption: '今日は快晴です。',
        prefecture: @city.prefecture,
        city: @city,
        weather: '快晴',
        feeling: 'ちょうどいい',
        expectation: '今と変化なさそう'
      )

      other_prefecture = FactoryBot.create(:prefecture, name: '東京都')
      @other_city = FactoryBot.create(:city, name: '渋谷区', prefecture: other_prefecture)
      @other_post = FactoryBot.create(
        :post,
        user: user,
        caption: '今日は曇りです。',
        prefecture: @other_city.prefecture,
        city: @other_city,
        weather: '曇り',
        feeling: '寒い',
        expectation: '回復しそう'
      )
    end

    context "caption: '晴'で検索した場合、曖昧検索できているか" do
      it '@postを返すこと' do
        expect(Post.search(caption: '晴')).to include(@post)
      end

      it '@other_postを返さないこと' do
        expect(Post.search(caption: '晴')).to_not include(@other_post)
      end
    end

    context '都道府県で検索した場合、一致検索できているか' do
      it '@postを返すこと' do
        expect(Post.search(prefecture_id: @city.prefecture.id)).to include(@post)
      end

      it '@other_postを返さないこと' do
        expect(Post.search(prefecture_id: @city.prefecture.id)).to_not include(@other_post)
      end
    end

    context '都道府県、市区町村で検索した場合、一致検索できているか' do
      it '@postを返すこと' do
        expect(Post.search(prefecture_id: @city.prefecture.id, city_id: @city.id)).to include(@post)
      end

      it '@other_postを返さないこと' do
        expect(Post.search(prefecture_id: @city.prefecture.id, city_id: @city.id)).to_not include(@other_post)
      end
    end

    context "weather: '快晴'で検索した場合、一致検索できているか" do
      it '@postを返すこと' do
        expect(Post.search(weather: '快晴')).to include(@post)
      end

      it '@other_postを返さないこと' do
        expect(Post.search(weather: '快晴')).to_not include(@other_post)
      end
    end

    context "caption: '雪'で検索した場合" do
      it '0件であること' do
        expect(Post.search(caption: '雪')).to be_empty
      end
    end

    context "weather: '雪'で検索した場合" do
      it '0件であること' do
        expect(Post.search(weather: '雪')).to be_empty
      end
    end
  end

  describe 'その他' do
    it '記事が新しい順に並んでいること' do
      FactoryBot.create(:post, created_at: 2.days.ago)
      most_recent_post = FactoryBot.create(:post, created_at: Time.zone.now)
      FactoryBot.create(:post, created_at: 5.minutes.ago)

      expect(most_recent_post).to eq Post.first
    end

    it '記事を削除すると、関連するコメントも削除されること' do
      post = FactoryBot.create(:post, :with_comments, comments_count: 1)
      expect { post.destroy }.to change { Comment.count }.by(-1)
    end

    it '記事を削除すると、関連するいいねも削除されること' do
      post = FactoryBot.create(:post, :with_likes, likes_count: 1)
      expect { post.destroy }.to change { Post.count }.by(-1)
    end
  end
end
