class GamesController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction, :season
  
  def index
    @games = Game.where(season: season).order(sort_column + " " + sort_direction).page(params[:page]).per(50)
    if request.xhr?
      render partial: "games", locals: {games: @games}
    end
  end

  def show
    @game = Game.find(params[:id])
    @home_team = @game.home_team
    @away_team = @game.away_team
    @tickets = get_seat_geek(@game)
  end

  private

  def sort_column
    Game.column_names.include?(params[:sort]) ? params[:sort] : "date"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

  def season
    params[:season] ? params[:season] : "13-14"
  end

  def get_seat_geek(game)
    url = Addressable::URI.new(
      scheme: "http",
      host: "api.seatgeek.com",
      path: "2/events",
      query_values: {"performers.slug" => game.home_team.name.split(" ").join("-").downcase,
                     datetime_local: game.date.to_s}).to_s

    results = JSON.parse(RestClient.get(url))
    puts results
    unless results["events"].empty?
      event = results["events"][0]
      tickets_hash = {min_price: event["stats"]["lowest_price"],
                      max_price: event["stats"]["highest_price"],
                      remaining_tickets: event["stats"]["listing_count"],
                      venue: event["venue"]["name"],
                      location: event["venue"]["display_location"],
                      link: event["url"]
                    }
      return tickets_hash
    end
    nil
  end
end