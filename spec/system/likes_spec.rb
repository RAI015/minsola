require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  let!(:user) do
    FactoryBot.create(:user,
                      :with_posts,
                      posts_count: 1)
  end
  let!(:alice) do
    FactoryBot.create(:user,
                      name: 'Alice',
                      email: 'alice@example.com',
                      password: 'password_alice')
  end

  it '既存の投稿にいいね/いいね解除する', js: true do
    visit root_path

    # ログインする
    click_link 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content '次回から自動的にログイン'

    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password_alice'
    click_button 'ログイン'
    expect(current_path).to eq feed_posts_path

    # 記事詳細へ移動する
    click_link '新着投稿'
    post = user.posts.first
    expect(page).to have_link 'a', href: "/posts/#{post.id}"
    click_link nil, href: "/posts/#{post.id}"
    expect(current_path).to eq "/posts/#{post.id}"

    # 投稿にいいね！する
    expect(page).to have_content '0 いいね！'
    expect do
      click_link 'いいね！'
      expect(page).to have_content '1 いいね済'
      expect(page).to_not have_content '0 いいね！'
    end.to change(post.likes, :count).by(1)

    # マイページに移動する→記事詳細へ移動する
    visit user_path(alice)
    expect(current_path).to eq "/users/#{alice.id}"
    expect(page).to have_content 'いいね 1'
    click_link 'いいね'
    click_link nil, href: "/posts/#{post.id}"
    expect(current_path).to eq "/posts/#{post.id}"

    # いいね！解除する
    expect(page).to have_content '1 いいね済'
    expect do
      click_link 'いいね済'
      expect(page).to have_content '0 いいね！'
      expect(page).to_not have_content '1 いいね済'
    end.to change(post.likes, :count).by(-1)

    # マイページに移動する
    visit user_path(alice)
    expect(page).to_not have_content 'いいね 1'
    expect(page).to have_content 'いいね 0'
  end
end
