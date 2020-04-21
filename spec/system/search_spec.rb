require 'rails_helper'

RSpec.describe 'Search', type: :system do
  let!(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678')
  end

  let!(:post1) do
    create(:post,
           caption: '今日は晴れそうです',
           prefecture_id: 1,  # 北海道
           city_id: 1,        # 札幌市中央区
           weather: '晴れ')
  end
  let!(:post2) do
    create(:post,
           caption: '今日は曇りそうです',
           prefecture_id: 13, # 東京都
           city_id: 667,      # 渋谷区
           weather: '曇り')
  end
  let!(:post3) do
    create(:post,
           caption: '今日は雨です',
           prefecture_id: 47, # 沖縄県
           city_id: 1856,     # 那覇市
           weather: '雨')
  end

  before '検索ページへ移動する' do
    visit root_path
    click_link '検索'
    expect(current_path).to eq search_posts_path
  end

  describe '投稿を検索する', js: true do
    it 'キャプションで検索できること' do
      # キャプション「晴れ」で検索する
      fill_in 'キャプション', with: '晴れ'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # キャプション「曇り」で検索する
      fill_in 'キャプション', with: '曇り'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # キャプション「雨」で検索する
      fill_in 'キャプション', with: '雨'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"

      # キャプション「今日」で検索する
      fill_in 'キャプション', with: '今日'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"
    end

    it '都道府県で検索できること' do
      # 「北海道」で検索する
      select '北海道', from: '都道府県'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 「東京都」で検索する
      select '東京都', from: '都道府県'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 「沖縄県」で検索する
      select '沖縄県', from: '都道府県'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"
    end

    it '都道府県、市区町村で検索できること' do
      # 「北海道」で検索する
      select '北海道', from: '都道府県'
      select '札幌市中央区', from: '市区町村'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 「東京都」で検索する
      select '東京都', from: '都道府県'
      select '渋谷区', from: '市区町村'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 「沖縄県」で検索する
      select '沖縄県', from: '都道府県'
      select '那覇市', from: '市区町村'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"
    end

    it '天気で検索できること' do
      # 天気「晴れ」で検索する
      select '晴れ', from: '天気'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 天気「曇り」で検索する
      select '曇り', from: '天気'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 天気「雨」で検索する
      select '雨', from: '天気'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"
    end
  end
end
