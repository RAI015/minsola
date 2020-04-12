class RelationshipsController < ApplicationController
  before_action :set_user, only: %i[create destroy]

  def create
    follow = current_user.active_relationships.build(follower_id: params[:user_id])
    follow.save
    # redirect_to user_path(params[:user_id])
  end

  def destroy
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow.destroy
    # redirect_to user_path(params[:user_id])
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
