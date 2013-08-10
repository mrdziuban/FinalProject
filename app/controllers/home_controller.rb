class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def search
    @results = PgSearch.multisearch(params[:query])
    @teams = @results.select {|r| r.searchable_type == "Team"}
    @players = @results.select {|r| r.searchable_type == "Player"}
    @goalies = @results.select {|r| r.searchable_type == "Goalie"}
    if request.xhr?
      render partial: "results", locals: {teams: @teams, 
                                          players: @players,
                                          goalies: @goalies,
                                          query: params[:query]}
    end
  end
end