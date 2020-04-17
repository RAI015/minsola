class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[create destroy]

  def create
    current_user.follow(@user) unless @user.followed_by?(current_user)
    respond_to do |format|
      format.html { refirect_to @user }
      format.js
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { refirect_to @user }
      format.js
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
