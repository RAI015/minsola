require 'rails_helper'

RSpec.describe 'Login', type: :system do
  let!(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678')
  end

  describe '通常ユーザー' do
    it '通常ユーザーがログイン/ログアウトする' do
      visit root_path

      # ログインページへ移動する
      click_link 'ログイン'
      expect(current_path).to eq login_path
      expect(page).to have_content '次回から自動的にログイン'

      # 失敗ケース
      fill_in 'メールアドレス', with: 'alice@example.com'
      fill_in 'パスワード', with: 'password_alice'
      click_button 'ログイン'
      expect(page).to have_content 'メールアドレスまたはパスワードが違います。'

      # 成功ケース
      fill_in 'メールアドレス', with: 'test@example.com'
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
      expect(current_path).to eq root_path
      expect(page).to have_content 'TestUserさん'

      # ログアウトする
      click_link 'TestUserさん'
      click_link 'ログアウト'

      expect(page).to_not have_content 'TestUserさん'
      expect(page).to have_link '新規登録'
      expect(page).to have_link 'ログイン'
    end
  end

  describe 'ゲストユーザー' do
    let!(:guest) { create(:user, :guest) }

    it 'ゲストユーザーとしてログインする' do
      visit root_path

      # ログインする
      click_link 'ログイン'
      expect(current_path).to eq login_path
      expect(page).to have_content '次回から自動的にログイン'

      fill_in 'メールアドレス', with: 'guest@example.com'
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
      expect(current_path).to eq root_path
      expect(page).to have_content 'GuestUserさん'
    end

    it 'かんたんログインができる(ゲストユーザーとしてログイン)' do
      visit root_path

      # ログインする
      click_link 'ログイン'
      expect(current_path).to eq login_path
      expect(page).to have_content '次回から自動的にログイン'

      click_button 'かんたんログイン'
      expect(current_path).to eq root_path
      expect(page).to have_content 'GuestUserさん'
    end
  end

  describe '管理者ユーザー' do
    let!(:admin) { create(:user, :admin) }
    let!(:guest) { create(:user, :guest) }
    let!(:post) { create(:post, :with_comments, comments_count: 3) }

    before '管理者としてログイン' do
      visit root_path

      # ログインする
      click_link 'ログイン'
      expect(current_path).to eq login_path
      expect(page).to have_content '次回から自動的にログイン'

      fill_in 'メールアドレス', with: 'admin@example.com'
      fill_in 'パスワード', with: '12345678'
      click_button 'ログイン'
      expect(current_path).to eq root_path
      expect(page).to have_content 'AdminUserさん'
      expect(page).to have_link 'すべてのユーザー'
    end

    it '管理者としてログインする' do
      # ユーザ一覧が表示できる
      click_link 'すべてのユーザー'
      expect(current_path).to eq users_path

      # 通常ユーザーに「このユーザーを削除する」があること
      click_link 'TestUser', href: "/users/#{user.id}"
      expect(current_path).to eq "/users/#{user.id}"
      expect(page).to have_content 'このユーザーを削除する'

      # ゲストユーザーに「このユーザーを削除する」がないこと
      click_link 'すべてのユーザー'
      click_link 'GuestUser', href: "/users/#{guest.id}"
      expect(current_path).to eq "/users/#{guest.id}"
      expect(page).to_not have_content 'このユーザーを削除する'

      # 管理者ユーザーに「このユーザーを削除する」がないこと
      click_link 'すべてのユーザー'
      click_link 'AdminUser', href: "/users/#{admin.id}"
      expect(current_path).to eq "/users/#{admin.id}"
      expect(page).to_not have_content 'このユーザーを削除する'
    end

    it '通常ユーザーを削除できること', js: true do
      # ユーザ一覧が表示できる
      click_link 'すべてのユーザー'
      expect(current_path).to eq users_path

      # 通常ユーザーに「このユーザーを削除する」があること
      click_link 'TestUser', href: "/users/#{user.id}"
      expect(current_path).to eq "/users/#{user.id}"
      expect(page).to have_content 'このユーザーを削除する'

      delete_link = find_link 'このユーザーを削除する'
      page.accept_confirm 'このユーザーを削除しますか？' do
        delete_link.click
      end
      expect(current_path).to eq users_path
      expect(page).to have_content "ユーザー「#{user.name}」は正常に削除されました"
      expect(User.where(email: 'test@example.com')).to be_empty
    end

    it '投稿を削除できること', js: true do
      # 記事詳細へ移動する
      click_link nil, href: "/posts/#{post.id}"
      expect(current_path).to eq "/posts/#{post.id}"
      expect(page).to have_link '削除'
      expect(page).to_not have_link '編集'

      delete_link = find_link '削除', href: "/posts/#{post.id}"
      page.accept_confirm '投稿を削除してもよろしいですか？' do
        delete_link.click
      end
      expect(current_path).to eq root_path
      expect(page).to have_content "「#{set_address(post.prefecture.name, post.city.name)}」のレポートが削除されました"
      expect(current_path).to_not eq "/posts/#{post.id}"
      expect(Post.find_by(id: post.id)).to be_nil
    end

    it 'コメントを削除できること', js: true do
      comment = post.comments.first
      # 記事詳細へ移動する
      click_link nil, href: "/posts/#{post.id}"
      expect(current_path).to eq "/posts/#{post.id}"
      expect(page).to have_link '削除'
      expect(page).to have_link '削除', href: "/comments/#{comment.id}"

      delete_link = find_link '削除', href: "/comments/#{comment.id}"
      page.accept_confirm 'コメントを削除してもよろしいですか？' do
        delete_link.click
      end
      expect(current_path).to eq "/posts/#{post.id}"
      expect(page).to have_content 'コメントが削除されました'
      expect(page).to_not have_link '削除', href: "/comments/#{comment.id}"
      expect(Comment.find_by(id: comment.id)).to be_nil
    end
  end
end
