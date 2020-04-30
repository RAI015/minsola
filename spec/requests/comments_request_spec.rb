require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe '#create' do
    context 'パラメータが揃っている場合' do
      it '正常に登録できること' do
        comment = build(:comment, comment: '今日は晴れそうです', post: post)
        expect { comment.save }.to change { post.comments.count }.by(1)
      end
    end

    context 'パラメータが揃っていない場合' do
      it '登録できないこと' do
        comment = build(:comment, comment: '', post: post)
        expect { comment.save }.to change { post.comments.count }.by(0)
      end
    end
  end

  describe '#destroy' do
    it '正常に削除できること' do
      comment = create(:comment, post: post)
      expect { comment.destroy }.to change { post.comments.count }.by(-1)
    end
  end
end
