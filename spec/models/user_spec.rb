# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)      not null
#  profile                :text(65535)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  it '名前、メール、パスワードがある場合、有効であること' do
    user = User.new(
      name: 'TestUser',
      email: 'test@expample.com',
      password: 'password'
    )
    expect(user).to be_valid
  end

  describe '存在性の検証' do
    it '名前がない場合、無効であること' do
      @user.name = ''
      @user.valid?
      expect(@user).to_not be_valid
    end

    it 'メールアドレスがない場合、無効であること' do
      @user.email = ''
      @user.valid?
      expect(@user).to_not be_valid
    end

    it 'パスワードがない場合、無効であること' do
      @user.password = @user.password_confirmation = ' ' * 8
      @user.valid?
      expect(@user).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it '名前が10文字以内の場合、有効であること' do
      @user.name = 'a' * 10
      expect(@user).to be_valid
    end

    it '名前が11文字以上の場合、登録できないこと' do
      @user.name = 'a' * 11
      expect(@user).to_not be_valid
    end
  end

  describe '一意性の検証' do
    it '重複したメールアドレスの場合、無効であること' do
      user1 = FactoryBot.create(:user, name: 'taro', email: 'taro@example.com')
      user2 = FactoryBot.build(:user, name: 'ziro', email: user1.email)
      expect(user2).to_not be_valid
    end
  end

  describe 'パスワードの検証' do
    it 'パスワードと確認用パスワードが間違っている場合、無効であること' do
      @user.password = 'password'
      @user.password_confirmation = 'pass'
      expect(@user).to_not be_valid
    end

    it 'パスワードが暗号化されていること' do
      user = FactoryBot.create(:user)
      expect(user.encrypted_password).to_not eq 'password'
    end
  end

end
