# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  comment    :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { FactoryBot.create(:comment) }

  it 'コメント、ポスト、ユーザーがある場合、有効であること' do
    user = FactoryBot.create(:user)
    post = FactoryBot.create(:post)
    comment = Comment.new(
      comment: 'コメント',
      post: post,
      user: user
    )
    expect(comment).to be_valid
  end

  describe '存在性の検証' do
    it 'コメントがない場合、無効であること' do
      comment.comment = ''
      comment.valid?
      expect(comment).to_not be_valid
    end

    it 'ポストがない場合、無効であること' do
      comment.post = nil
      comment.valid?
      expect(comment).to_not be_valid
    end

    it 'ユーザーがない場合、無効であること' do
      comment.user = nil
      comment.valid?
      expect(comment).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it 'コメントが1000文字以内の場合、有効であること' do
      comment.comment = 'a' * 1000
      expect(comment).to be_valid
    end

    it 'コメントが1001文字以上の場合、登録できないこと' do
      comment.comment = 'a' * 1001
      expect(comment).to_not be_valid
    end
  end
end
