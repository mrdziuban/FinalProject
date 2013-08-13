class ForumsController < ApplicationController
  def index
    @forums = Forum.all
  end

  def show
    @forum = Forum.find(params[:id])
    @topics = @forum.topics
    if request.xhr?
      render partial: "forum", locals: {forum: @forum, topics: @topics, team: @forum.team}
    end
  end
end