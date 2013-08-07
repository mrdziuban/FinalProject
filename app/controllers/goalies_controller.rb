class GoaliesController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction, :season
  
  def index
    @goalies = Goalie.order(sort_column + " " + sort_direction).page(params[:page]).per(50)
    if request.xhr?
      render partial: "goalies", locals: {goalies: @goalies}
    end
  end

  def show
    @goalie = Goalie.find(params[:id])
  end

  private

  def sort_column
    Goalie.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def season
    nil
  end
end