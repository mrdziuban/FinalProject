class PlayersController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction

  def index
    @players = Player.order(sort_column + " " + sort_direction).page(params[:page]).per(50)
  end

  def show
    @player = Player.find(params[:id])
  end

  private

  def sort_column
    Player.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end