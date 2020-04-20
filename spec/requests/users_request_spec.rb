require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:another_user) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, :admin) }

  describe '#index' do
    context '管理者ユーザーの場合' do
      it '正常にアクセスできること' do
        sign_in admin
        get users_path
        expect(response).to have_http_status 200
      end
    end

    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        get users_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end

    context '未ログイン状態のとき' do
      it '記事一覧ページにリダイレクトされること' do
        sign_in another_user
        get users_path
        expect(response).to have_http_status 302
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#destroy' do
    context '管理者ユーザーの場合' do
      it 'ユーザーを正常に削除できること' do
        sign_in admin
        expect { delete user_path(user) }.to change { User.count }.by(-1)
        expect(response).to redirect_to users_path
      end
    end

    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        delete user_path(user)
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end

    context '認可されていないユーザーがアクセスした場合' do
      it 'ユーザーを削除できず、記事一覧ページにリダイレクトされること' do
        sign_in another_user
        expect { delete user_path(user) }.to change { User.count }.by(0)
        expect(response).to redirect_to root_path
      end
    end
  end
end
