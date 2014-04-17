require 'addressable/uri'
require 'open-uri'

class GamesController < ApplicationController
  before_filter :authenticate_user!
  helper_method :sort_column, :sort_direction, :season, :team_id
  
  def index
    if params[:team_id]
      @games = Game.where(['(home = ? OR away = ?) AND season = ?',
                          params[:team_id].upcase,
                          params[:team_id].upcase,
                          season]).order(sort_column + " " + sort_direction)
                          .page(params[:page]).per(50)
    else
      @games = Game.where(season: season).order(sort_column + " " + sort_direction).page(params[:page]).per(50)
    end

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

  def links
    games_json = open('http://live.nhl.com/GameData/SeasonSchedule-20132014.json').read
    games = JSON.parse(games_json)
    games = games.select do |game|
      game['est'].include?(DateTime.now.strftime('%Y%m%d'))
    end

    @final_games = []

    games.each do |game|
      game_id = game['id'].to_s[4..-1]
      game_id = game_id.insert(2, '_')
      date_arr = game['est'].split(' ')
      date = "#{date_arr[0].insert(4, '-').insert(7, '-')} #{date_arr[1][0..1].to_i % 12}:#{date_arr[1][3..4]}"
      url = "http://smb.cdnak.neulion.com/fs/nhl/mobile/feed_new/data/streams/2013/ipad/#{game_id}.json"
      p url
      game_info_json = open(url).read
      game_info = JSON.parse(game_info_json)
      begin
        @final_games << {
          id: game_id,
          date: date,
          home: game['h'],
          away: game['a'],
          home_stream: game_info['gameStreams']['ipad']['home']['live']['bitrate0'],
          away_stream: game_info['gameStreams']['ipad']['away']['live']['bitrate0']
        }
      rescue
        next
      end
    end
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

  def team_id
    params[:team_id] ? params[:team_id] : nil
  end

  def get_seat_geek(game)
    url = Addressable::URI.new(
      scheme: "http",
      host: "api.seatgeek.com",
      path: "2/events",
      query_values: {"performers.slug" => game.home_team.name.split(" ").join("-").downcase,
                     datetime_local: game.date.to_s}).to_s

    results = JSON.parse(RestClient.get(url))

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