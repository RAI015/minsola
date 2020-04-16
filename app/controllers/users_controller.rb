class UsersController < ApplicationController
  before_action :admin_user, only: :destroy
  before_action :set_target_user, only: %i[show edit update destroy]

  def index
    @users = User.page(params[:page]).per(24)
  end

  def show
    @posts = Post.where(user_id: @user.id).order(created_at: :DESC).includes(:prefecture, :city)
    @like_posts = @user.like_posts.includes(:prefecture, :city)

    # @posts = @posts.page(params[:page]).per(PER)
    # @like_posts = @user.like_posts.page(params[:page]).per(PER)

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

  def destroy
    @user.destroy
    flash[:success] = "ユーザー「#{@user.name}」は正常に削除されました"
    redirect_to users_path
  end

  def like_posts; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :avatar, :profile)
  end

  def set_target_user
    @user = User.find(params[:id])
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
