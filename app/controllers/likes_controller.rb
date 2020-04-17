class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[create destroy]

  def create
    current_user.like(@post) unless current_user.like?(@post)
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  def destroy
    current_user.unlike(@post)
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
