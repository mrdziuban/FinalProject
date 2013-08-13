class TopicsController < ApplicationController
  def create
    @topic = Topic.new(params[:topic])
    @topic.user_id = current_user.id
    @topic.forum_id = params[:forum_id]
    @topic.save
    if request.xhr?
      render partial: "forums/forum", locals: {topics: Topic.where(forum_id: @topic.forum_id)}
    end
  end

  def show
    @topic = Topic.search_by_title(params[:id].gsub("_", " "))
  end

  def update
    @topic = Topic.search_by_title(params[:id].gsub("_", " "))
    if @topic.user != current_user
      render nothing: true
    else
      @topic.update_attributes(params[:topic])
      if request.xhr?
        render partial: "topic"
      end
    end
  end

  def destroy
    @topic = Topic.search_by_title(params[:id].gsub("_", " "))
    if @topic.user != current_user
      render nothing: true
    else
      @topic.destroy
      redirect_to forum_url(@topic.forum)
    end
  end
end