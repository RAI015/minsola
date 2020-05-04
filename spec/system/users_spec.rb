require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678')
  end
  let!(:admin) do
    create(:user,
           name: 'AdminUser',
           email: 'admin@example.com',
           password: '12345678',
           admin: true)
  end

  it 'ユーザープロフィールを編集する' do
    visit root_path

    # ログインする
    click_link 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content '次回から自動的にログイン'

    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード', with: '12345678'
    click_button 'ログイン'
    expect(current_path).to eq feed_posts_path

    click_link 'TestUserさん'
    click_link 'マイページ'
    expect(current_path).to eq user_path(user)
    expect(page).to have_content 'TestUser'

    click_link 'プロフィール編集'
    expect(current_path).to eq edit_user_path(user)
    expect(page).to have_content 'ユーザー名（１０文字以内）'
    expect(page).to have_content 'メールアドレス'
    expect(page).to have_content '自己紹介（１５０文字以内）'

    attach_file 'user[avatar]', "#{Rails.root}/spec/fixtures/rspec_test.jpg", make_visible: true
    fill_in 'ユーザー名', with: 'Alice'
    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in '自己紹介', with: '初めまして、よろしくお願いします。'
    click_on '変更を保存する'
    expect(current_path).to eq user_path(user)

    user.reload
    aggregate_failures do
      expect(user.name).to eq 'Alice'
      expect(user.email).to eq 'alice@example.com'
      expect(user.profile).to eq '初めまして、よろしくお願いします。'
    end
  end

  it '管理者ユーザーが別のユーザーを削除する', js: true do
    visit root_path

    # ログインする
    click_link 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content '次回から自動的にログイン'

    fill_in 'メールアドレス', with: 'admin@example.com'
    fill_in 'パスワード', with: '12345678'
    click_button 'ログイン'
    expect(current_path).to eq feed_posts_path
    expect(page).to have_content 'AdminUserさん'
    expect(page).to have_content 'すべてのユーザー'

    # ユーザ一覧へ移動する
    click_link 'すべてのユーザー'
    expect(current_path).to eq users_path
    expect(page).to have_content 'TestUser'
    expect(User.where(email: 'test@example.com')).to be_exist

    delete_link = find_link 'このユーザーを削除する'
    page.accept_confirm 'このユーザーを削除しますか？' do
      delete_link.click
    end
    expect(page).to have_content "ユーザー「#{user.name}」は正常に削除されました"
    expect(User.where(email: 'test@example.com')).to be_empty
  end
end
