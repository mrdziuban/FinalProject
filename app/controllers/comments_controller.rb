class CommentsController < ApplicationController
  def create
    @comment = Comment.create!(text: params[:text], topic_id: params[:topic_id], user_id: params[:user_id])
    @comments = @comment.topic.comments_by_parent
    if request.xhr?
      render partial: "topics/comment", locals: {comments_hash: @comments, comment: @comment}
    end
  end

  def destroy

  end
end