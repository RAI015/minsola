class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to feed_posts_path
    else
      redirect_to posts_path
    end
  end
end
