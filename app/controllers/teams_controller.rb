class TeamsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @standings = Team.standings
  end

  def show
    @team = Team.find_by_abbrev(params[:id].upcase)
    unless @team
      redirect_to standings_url
    else
      @standings = Team.standings
      @standings.each do |div, teams_hash|
        if teams_hash.keys.include?(@team.abbrev.to_sym)
          @standings = @standings[div]
          @standings[:division] = div
        end
      end
      @players = @team.players.sort_by { |p| p.name.split(" ")[1] }
      @goalies = @team.goalies.sort_by {|g| g.gp}.reverse
      @games = @team.recent_and_upcoming_games
    end
  end
end