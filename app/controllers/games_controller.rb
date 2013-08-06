class GamesController < ApplicationController
  def index

  end

  def show
    @game = Game.find(params[:id])
    @home_team = @game.home_team
    @away_team = @game.away_team
  end
end