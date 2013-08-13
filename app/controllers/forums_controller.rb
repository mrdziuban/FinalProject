class ForumsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @forums = Forum.all
  end

  def show
    @forum = Forum.find(params[:id])
    @topics = Topic.where(forum_id: @forum.id).order("id asc").page(params[:page]).per(20)
    if request.xhr?
      render partial: "forum", locals: {forum: @forum, topics: @topics}
    end
  end
end