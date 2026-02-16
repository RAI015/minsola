class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  before_action :set_comment, only: [:destroy]
  before_action :correct_comment_user, only: [:destroy]

  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to comment.post
    else
      redirect_to comment.post, flash: {
        comment: comment,
        error_messages: comment.errors.full_messages
      }
    end
  end

  def destroy
    @comment.destroy
    flash[:success] = 'コメントが削除されました'
    redirect_to @comment.post
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def correct_comment_user
    redirect_to(root_url) unless @comment.user == current_user || current_user.admin?
  end

  def comment_params
    params.require(:comment).permit(:comment, :post_id, :user_id)
  end
end
