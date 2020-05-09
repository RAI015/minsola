class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index destroy]
  before_action :admin_user, only: %i[index destroy]
  before_action :set_target_user, only: %i[show edit update destroy]

  def index
    @users = User.order(admin: :DESC, id: :ASC).page(params[:page]).per(PER * 2)
  end

  def show
    @posts = @user.posts.includes(:prefecture, :city)
    @like_posts = @user.like_posts.includes(:prefecture, :city)
    @followings = @user.followings
    @followers = @user.followers
  end

  def edit; end

  def update
    if @user.update(user_params)
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
