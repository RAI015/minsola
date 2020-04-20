require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe '#new' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        get new_post_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#create' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        post_params = FactoryBot.attributes_for(:post)
        post posts_path, params: { post: post_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#edit' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        post = FactoryBot.create(:post)
        get edit_post_path(post)
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end

    context '認可されていないユーザーがアクセスした場合' do
      # 投稿者とログインユーザーが異なる場合
      it '一覧ページにリダイレクトされること' do
        # ex)posts/1/editに直接URLを叩くと投稿者でないのに入れて編集できてしまうのは良くない
        # correct_userで対処
        user = FactoryBot.create(:user)
        user_post = FactoryBot.create(:post, user: user)

        another_user = FactoryBot.create(:user)
        sign_in another_user

        get edit_post_path(user_post)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#update' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        post = FactoryBot.create(:post)
        get edit_post_path(post)
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end

    context '認可されていないユーザーがアクセスした場合' do
      it '投稿を更新できず、一覧ページにリダイレクトされること' do
        user = FactoryBot.create(:user)
        user_post = FactoryBot.create(:post, user: user, caption: '今日は晴れそうです')

        another_user = FactoryBot.create(:user)
        sign_in another_user
        another_user_post_params = FactoryBot.attributes_for(:post, caption: '今日は曇りそうです')

        patch post_path(user_post), params: { post: another_user_post_params }
        expect(user_post.reload.caption).to eq '今日は晴れそうです'
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#destroy' do
    let!(:post) { FactoryBot.create(:post) }

    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        delete post_path(post)
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end

    context '認可されていないユーザーがアクセスした場合' do
      it '投稿を削除できず、一覧ページにリダイレクトされること' do
        another_user = FactoryBot.create(:user)
        sign_in another_user
        expect { delete post_path(post) }.to change { Post.count }.by(0)
        expect(response).to redirect_to root_path
      end
    end
  end
end
