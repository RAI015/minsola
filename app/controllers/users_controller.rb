class UsersController < ApplicationController
  before_action :set_target_user

  def show
    @posts = Post.where(user_id: @user.id).order(created_at: :DESC)
    @like_posts = @user.like_posts

    # @posts = @posts.page(params[:page]).per(12)
    # @like_posts = @user.like_posts.page(params[:page]).per(12)

    # respond_to do |format|
    #   format.html
    #   format.js
    # end

    @followings = @user.followings
    @followers = @user.followers
  end

  def edit; end

  def update
    if @user.update(user_params)
      # flash[:success] = "#{@user.name}さんのユーザー情報を更新しました"
      redirect_to @user
    else
      redirect_to edit_user_path(@user), flash: {
        user: @user,
        error_messages: @user.errors.full_messages
      }
    end
  end

  def like_posts; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :profile)
  end

  def set_target_user
    @user = User.find(params[:id])
  end
end
