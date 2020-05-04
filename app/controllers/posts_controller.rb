class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  before_action :set_target_post, only: %i[show edit update destroy]
  before_action :correct_user, only: %i[edit update destroy]
  before_action :set_form_title_button, only: %i[new edit]
  before_action :set_weathers, :set_feelings, :set_expectations, only: %i[new edit search]

  def index
    @posts = Post.page(params[:page]).per(PER)
    @posts = @posts.includes(:user, :prefecture, :city)
  end

  def popular
    @popular_posts = Post.unscoped.joins(:likes).group(:post_id).order(Arel.sql('count(likes.user_id) desc')).page(params[:page]).per(PER)
    @popular_posts = @popular_posts.includes(:user, :prefecture, :city)
  end

  def feed
    if user_signed_in?
      @feed_posts = current_user.feed.page(params[:page]).per(12)
      @feed_posts = @feed_posts.includes(:user, :prefecture, :city)
    end
  end

  def search
    @search_params = post_search_params
    @search_posts = Post.search(@search_params).page(params[:page]).per(PER).includes(:user, :prefecture, :city)
  end

  def new
    @post = Post.new(flash[:post])
  end

  def create
    post = current_user.posts.build(post_params)
    if post.save
      redirect_to root_path, flash: { success: "「#{set_address(post.prefecture.name, post.city.name)}」のレポートを投稿しました" }
    else
      redirect_to new_post_path, flash: {
        post: post,
        error_messages: post.errors.full_messages
      }
    end
  end

  def destroy
    @post.destroy
    redirect_to root_path, flash: { success: "「#{set_address(@post.prefecture.name, @post.city.name)}」のレポートが削除されました" }
  end

  def show
    @comment = Comment.new(post_id: @post.id)
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, flash: { success: "「#{set_address(@post.prefecture.name, @post.city.name)}」のレポートを編集しました" }
    else
      redirect_back fallback_location: @post, flash: {
        post: @post,
        error_messages: @post.errors.full_messages
      }
    end
  end

  def cities_select
    render partial: 'cities', locals: { prefecture_id: params[:prefecture_id] } if request.xhr?
  end

  def set_weathers
    @weathers = WEATHERS
  end

  def set_feelings
    @feelings = FEELINGS
  end

  def set_expectations
    @expectations = EXPECTATIONS
  end

  private

  def post_params
    params.require(:post).permit(:caption, :image, :user_id, :prefecture_id, :city_id, :weather, :feeling, :expectation)
  end

  def set_target_post
    @post = Post.find(params[:id])
  end

  def correct_user
    redirect_to(root_url) unless (@post.user == current_user) || current_user.admin?
  end

  def set_form_title_button
    if params['action'] == 'new'
      @form_title = '新しい投稿'
      @form_button = '投稿する'
    else
      @form_title = '投稿を編集'
      @form_button = '更新する'
    end
  end

  def post_search_params
    params.fetch(:post, {}).permit(:caption, :prefecture_id, :city_id, :weather)
  end
end
