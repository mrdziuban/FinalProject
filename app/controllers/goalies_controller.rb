class GoaliesController < ApplicationController
  def index

  end

  def show
    @goalie = Goalie.find(params[:id])
  end
end