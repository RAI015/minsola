require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let!(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678')
  end
  let!(:post) { create(:post) }

  it '既存の投稿にコメントをして、削除をする', js: true do
    visit root_path

    # ログインする
    click_link 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content '次回から自動的にログイン'

    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード', with: '12345678'
    click_button 'ログイン'
    expect(current_path).to eq feed_posts_path

    # 記事詳細へ移動する
    click_link '新着投稿'
    expect(page).to have_link 'a', href: "/posts/#{post.id}"
    click_link nil, href: "/posts/#{post.id}"
    expect(current_path).to eq "/posts/#{post.id}"

    # コメントを投稿する
    fill_in 'comment[comment]', with: 'こんにちは^_^.'
    click_button 'コメントを送信'
    expect(page).to have_content 'こんにちは^_^.'

    fill_in 'comment[comment]', with: 'おはようございます。'
    click_button 'コメントを送信'
    expect(page).to have_content 'おはようございます。'

    # コメントを削除する
    comment = post.comments.find_by!(comment: 'こんにちは^_^.')
    delete_link = find_link '削除', href: "/comments/#{comment.id}"

    page.accept_confirm 'コメントを削除してもよろしいですか？' do
      delete_link.click
    end
    expect(page).to have_content 'コメントが削除されました'
    expect(Comment.where(id: comment.id)).to be_empty
  end
end
