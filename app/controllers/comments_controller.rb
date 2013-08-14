class CommentsController < ApplicationController
  def create
    @comment = Comment.create!(text: params[:text], topic_id: params[:topic_id], user_id: params[:user_id])
    @comments = @comment.topic.comments_by_parent
    if request.xhr?
      render partial: "topics/comment", locals: {comments_hash: @comments, comment: @comment}
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update_attribute(:text, params[:text])
    @comments = @comment.topic.comments_by_parent
    if request.xhr?
      render partial: "topics/comment", locals: {comments_hash: @comments, comment: @comment}
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    render nothing: true
  end
end