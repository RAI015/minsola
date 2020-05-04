require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let!(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678')
  end

  it '新規投稿、編集、削除をする', js: true do
    visit root_path

    # ログインする
    click_link 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content '次回から自動的にログイン'

    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード', with: '12345678'
    click_button 'ログイン'
    expect(current_path).to eq feed_posts_path

    # 新規投稿する
    find('.new-post-btn--pc').click
    expect(current_path).to eq new_post_path
    expect(page).to have_content '新しい投稿'

    attach_file 'post[image]', "#{Rails.root}/spec/fixtures/rspec_test.jpg", make_visible: true
    fill_in 'キャプション（３００文字以内）', with: '今日は晴れそうです'
    select '東京都', from: '都道府県'
    select '渋谷区', from: '市区町村'
    select '晴れ', from: '天気（今の天気は？）'
    select 'ちょうどいい', from: '体感（今の体感は？）'
    select '変化なさそう', from: '予想（数時間後は？）'
    click_button '投稿する'
    sleep 5

    post = Post.first
    aggregate_failures do
      expect(post.caption).to eq '今日は晴れそうです'
      expect(post.weather).to eq '晴れ'
      expect(post.feeling).to eq 'ちょうどいい'
      expect(post.expectation).to eq '変化なさそう'
      expect(current_path).to eq feed_posts_path
      expect(page).to have_link 'a', href: "/posts/#{post.id}"
    end

    # 投稿を編集する
    click_link nil, href: "/posts/#{post.id}"
    expect(current_path).to eq "/posts/#{post.id}"
    click_link '編集'
    expect(current_path).to eq edit_post_path(post)
    expect(page).to have_content '投稿を編集'

    fill_in 'キャプション（３００文字以内）', with: '今日は曇りそうです'
    click_button '更新する'
    sleep 1

    expect(current_path).to eq "/posts/#{post.id}"
    expect(page).to_not have_content '今日は晴れそうです'
    expect(page).to have_content '今日は曇りそうです'

    # 投稿を削除する
    delete_link = find_link '削除'
    page.accept_confirm '投稿を削除してもよろしいですか？' do
      delete_link.click
    end
    sleep 1

    expect(current_path).to eq feed_posts_path
    expect(page).to have_content "「#{set_address(post.prefecture.name, post.city.name)}」のレポートが削除されました"
    expect(Post.where(id: post.id)).to be_empty
    expect(page).to_not have_link 'a', href: "/posts/#{post.id}"
  end

  describe 'フィード関係' do
    let!(:alice) { create(:user, name: 'alice') }
    let!(:bob) { create(:user, name: 'bob') }
    let!(:carol) { create(:user, name: 'carol') }

    let!(:alice_post) { create(:post, user: alice) }
    let!(:bob_post) { create(:post, user: bob) }
    let!(:carol_post) { create(:post, user: carol) }

    before 'aliceでログインする' do
      visit root_path

      click_link 'ログイン'
      expect(current_path).to eq login_path
      expect(page).to have_content '次回から自動的にログイン'

      fill_in 'メールアドレス', with: alice.email
      fill_in 'パスワード', with: alice.password
      click_button 'ログイン'
      expect(current_path).to eq feed_posts_path
    end

    it 'フィードに自身の投稿が表示されるか' do
      click_link 'フィード'
      within(:css, '.post-cards') do
        expect(page).to have_link 'a', href: "/posts/#{alice_post.id}"
        expect(page).to_not have_link 'a', href: "/posts/#{bob_post.id}"
        expect(page).to_not have_link 'a', href: "/posts/#{carol_post.id}"

        expect(page).to have_link 'alice'
        expect(page).to_not have_link 'bob'
        expect(page).to_not have_link 'carol'
      end
    end

    it '他のユーザーをフォローし、フィードに表示されるか' do
      alice.follow(bob)
      click_link 'フィード'
      within(:css, '.post-cards') do
        expect(page).to have_link 'a', href: "/posts/#{alice_post.id}"
        expect(page).to have_link 'a', href: "/posts/#{bob_post.id}"
        expect(page).to_not have_link 'a', href: "/posts/#{carol_post.id}"

        expect(page).to have_link 'alice'
        expect(page).to have_link 'bob'
        expect(page).to_not have_link 'carol'
      end
    end

    it '他のユーザーをアンフォローし、フィードから消えるか' do
      alice.follow(bob)
      click_link 'フィード'
      within(:css, '.post-cards') do
        expect(page).to have_link 'a', href: "/posts/#{alice_post.id}"
        expect(page).to have_link 'a', href: "/posts/#{bob_post.id}"
        expect(page).to_not have_link 'a', href: "/posts/#{carol_post.id}"

        expect(page).to have_link 'alice'
        expect(page).to have_link 'bob'
        expect(page).to_not have_link 'carol'
      end

      alice.unfollow(bob)
      click_link 'フィード'
      within(:css, '.post-cards') do
        expect(page).to have_link 'a', href: "/posts/#{alice_post.id}"
        expect(page).to_not have_link 'a', href: "/posts/#{bob_post.id}"
        expect(page).to_not have_link 'a', href: "/posts/#{carol_post.id}"

        expect(page).to have_link 'alice'
        expect(page).to_not have_link 'bob'
        expect(page).to_not have_link 'carol'
      end
    end
  end
end
