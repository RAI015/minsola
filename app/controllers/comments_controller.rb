class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      flash[:success] = 'コメントが投稿されました'
      redirect_to comment.post
    else
      redirect_to comment.post, flash: {
        comment: comment,
        error_messages: comment.errors.full_messages
      }
      # flash[:comment] = comment
      # flash[:error_messages] = comment.errors.full_messages
      # redirect_back fallback_locaion: comment.post
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:success] = 'コメントが削除されました'
    redirect_to comment.post
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :post_id, :user_id)
  end
end
