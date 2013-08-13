class TopicsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @topic = Topic.new(params[:topic])
    @topic.user_id = current_user.id
    @topic.forum_id = params[:forum_id]
    if @topic.save
      redirect_to forum_topic_url(@topic.forum, @topic)
    else
      redirect_to forum_url(@topic.forum, topic: "invalid")
    end
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.user != current_user
      render nothing: true
    else
      @topic.update_attributes(params[:topic])
      redirect_to forum_topic_url(@topic)
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.user != current_user
      render nothing: true
    else
      @topic.destroy
      redirect_to forum_url(@topic.forum)
    end
  end
end