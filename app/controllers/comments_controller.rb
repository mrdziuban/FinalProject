class CommentsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    @comment = Comment.create!(params[:comment])
    @comments = @comment.topic.comments_by_parent
    if request.xhr?
      render partial: "topics/comment", locals: {comments_hash: @comments, comment: @comment}
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update_attributes!(params[:comment])
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