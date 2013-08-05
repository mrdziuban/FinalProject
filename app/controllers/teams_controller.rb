class TeamsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @standings = Team.standings
  end
end