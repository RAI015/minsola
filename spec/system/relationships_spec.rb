require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let!(:alice) do
    create(:user,
           name: 'Alice',
           email: 'alice@example.com',
           password: 'password_alice')
  end
  let!(:bob) do
    create(:user,
           name: 'Bob',
           email: 'bob@example.com',
           password: 'password_bob')
  end
  let!(:bob_post) do
    create(:post, user: bob)
  end

  it 'ユーザーをフォロー/フォロー解除する', js: true do
    visit root_path

    # Aliceがログインする
    click_link 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content '次回から自動的にログイン'

    fill_in 'メールアドレス', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password_alice'
    click_button 'ログイン'
    expect(current_path).to eq feed_posts_path

    # Bobのページへ移動する
    click_link '新着投稿'
    expect(page).to have_link 'a', href: "/posts/#{bob_post.id}"
    click_link 'Bob'
    expect(current_path).to eq "/users/#{bob.id}"

    # Bobをフォローする
    expect(page).to have_content 'フォロワー 0'
    expect do
      click_link 'フォロー'
      expect(page).to have_content 'フォロワー 1'
      expect(page).to_not have_content 'フォロワー 0'
      expect(page).to have_content 'フォロー中'
    end.to change(alice.followings, :count).by(1) &
           change(bob.followers, :count).by(1)

    # マイページ(Alice)に移動する
    visit user_path(alice)
    expect(current_path).to eq "/users/#{alice.id}"
    click_link 'フォロー'
    expect(page).to have_content 'フォロー 1'
    expect(page).to have_content 'Bob'
    expect(page).to have_content 'フォロー中'

    # Bobのフォローを解除する
    expect do
      click_link 'フォロー中'
      expect(page).to have_content 'フォロー 0'
      expect(page).to_not have_content 'フォロー 1'
      expect(page).to have_content 'フォロー'
    end.to change(alice.followings, :count).by(-1) &
           change(bob.followers, :count).by(-1)

    visit user_path(alice)
    click_link 'フォロー'
    expect(find('.tab-content')).to_not have_content 'Bob'
    expect(page).to have_content '誰もフォローしていません'

    # Bobのユーザーページに移動する
    visit user_path(bob)
    click_link 'フォロワー'
    expect(find('.tab-content')).to_not have_content 'Alice'
    expect(page).to have_content 'フォローされていません'
  end
end
