require 'open-uri'

class Game < ActiveRecord::Base
  attr_accessible :away, :date, :home, :result, :season, :time

  belongs_to :away_team, class_name: "Team", foreign_key: "away", primary_key: "abbrev"
  belongs_to :home_team, class_name: "Team", foreign_key: "home", primary_key: "abbrev"



  TEAM_ABBREVS = {
    "boston" => :BOS,
    "buffalo" => :BUF,
    "calgary" => :CGY,
    "chicago" => :CHI,
    "detroit" => :DET,
    "edmonton" => :EDM,
    "carolina" => :CAR,
    "los angeles" => :LOS,
    "montreal" => :MON,
    "dallas" => :DAL,
    "new jersey" => :NJD,
    "ny islanders" => :NYI,
    "ny rangers" => :NYR,
    "philadelphia" => :PHI,
    "pittsburgh" => :PIT,
    "colorado" => :COL,
    "st. louis" => :STL,
    "toronto" => :TOR,
    "vancouver" => :VAN,
    "washington" => :WAS,
    "phoenix" => :PHO,
    "san jose" => :SJS,
    "ottawa" => :OTT,
    "tampa bay" => :TAM,
    "anaheim" => :ANA,
    "florida" => :FLA,
    "winnipeg" => :WPG,
    "columbus" => :CBJ,
    "minnesota" => :MIN,
    "nashville" => :NSH
  }

  TEAMS = {
    :BOS => "boston bruins",
    :BUF => "buffalo sabres",
    :CGY => "calgary flames",
    :CHI => "chicago blackhawks",
    :DET => "detroit red wings",
    :EDM => "edmonton oilers",
    :CAR => "carolina hurricanes",
    :LOS => "los angeles kings",
    :MON => "montreal canadiens",
    :DAL => "dallas stars",
    :NJD => "new jersey devils",
    :NYI => "new york islanders",
    :NYR => "new york rangers",
    :PHI => "philadelphia flyers",
    :PIT => "pittsburgh penguins",
    :COL => "colorado avalanche",
    :STL => "st louis blues",
    :TOR => "toronto maple leafs",
    :VAN => "vancouver canucks",
    :WAS => "washington capitals",
    :PHO => "phoenix coyotes",
    :SJS => "san jose sharks",
    :OTT => "ottawa senators",
    :TAM => "tampa bay lightning",
    :ANA => "anaheim ducks",
    :FLA => "florida panthers",
    :WPG => "winnipeg jets",
    :CBJ => "columbus blue jackets",
    :MIN => "minnesota wild",
    :NSH => "nashville predators"
  }

  def stubhub
    date = self.date

    home = self.home
    home = TEAMS[home.to_sym]

    away = self.away
    away = TEAMS[away.to_sym]

    events = Stubhub::Event.search("#{home} #{away} NHL")
    event = events.select {|ev| date.to_s == ev.event_date_local}[0]

    if event
      if event.venue_name == "Verizon Center Washington DC"
        venue = "Verizon Center"
      elsif event.venue_name == "Wells Fargo Center Philadelphia"
        venue = "Wells Fargo Center"
      else
        venue = event.venue_name
      end
      tickets_hash = {}
      tickets_hash[:min_price] = event.minPrice
      tickets_hash[:remaining_tickets] = event.totalTickets
      tickets_hash[:venue] = venue
      tickets_hash[:location] = "#{event.city}, #{event.state}"
      tickets_hash[:link] = "http://www.stubhub.com/#{event.urlpath}"

      return tickets_hash
    end

    nil
  end

  def self.scrape1213
    game_stats_url = "http://www.nhl.com/ice/schedulebyseason.htm?season=20122013&gameType=2&team=&network=&venue="
    game_stats_page = Nokogiri::HTML(open(game_stats_url))
    game_stats_table = game_stats_page.css(".data.schedTbl")
    game_stats_hash = {}

    (game_stats_table.css("tr").length - 1).times do |i|
      game_stats_hash[i + 1] = {}
    end

    game_stats_table.css("tr").each_with_index do |tr, i|
      next if i == 0
      date = tr.css("td.date .skedStartDateSite").text.strip[4..-1]
      date = Date.parse(date)
      away = tr.css("td.team")[0].css("div a").text.strip
      away = I18n.transliterate(away)
      away = TEAM_ABBREVS[away.downcase]
      home = tr.css("td.team")[1].css("div a").text.strip
      home = I18n.transliterate(home)
      home = TEAM_ABBREVS[home.downcase]
      time = tr.css("td.time .skedStartTimeEST").text.strip[0..-4]
      if date < Date.today
        away_score = tr.css("td.tvInfo span")[0].text.strip.gsub("\n", "")
        home_score = tr.css("td.tvInfo span")[1].text.strip
        result = away_score + " - " + home_score
      else
        result = nil
      end

      game_stats_hash[i][:date] = date.to_s
      game_stats_hash[i][:away] = away
      game_stats_hash[i][:home] = home
      game_stats_hash[i][:time] = time
      game_stats_hash[i][:result] = result
      game_stats_hash[i][:season] = "12-13"
    end

    game_stats_hash.each do |i, val|
      g = Game.find_by_id(i + Game.all.length)
      if g
        g.update_attributes(val)
      else
        Game.create!(val)
      end
    end
  end


  def self.scrape1314
    game_stats_url = "http://www.nhl.com/ice/schedulebyseason.htm"
    game_stats_page = Nokogiri::HTML(open(game_stats_url))
    game_stats_table = game_stats_page.css(".data.schedTbl")
    game_stats_hash = {}

    1230.times do |i|
      game_stats_hash[i + 1] = {}
    end

    j = 1

    game_stats_table.css("tr").each_with_index do |tr, i|
      next if i == 0 || tr.css("td").length != 6
      date = tr.css("td.date .skedStartDateSite").text.strip[4..-1]
      date = Date.parse(date)
      away = tr.css("td.team")[0].css(".teamName a").text.strip
      away = I18n.transliterate(away)
      away = TEAM_ABBREVS[away.downcase]
      home = tr.css("td.team")[1].css(".teamName a").text.strip
      home = I18n.transliterate(home)
      home = TEAM_ABBREVS[home.downcase]
      time = tr.css("td.time .skedStartTimeEST").text.strip[0..-4]
      if date < Date.today
        away_score = tr.css("td.tvInfo span")[0].text.strip.gsub("\n", "")
        home_score = tr.css("td.tvInfo span")[1].text.strip
        result = away_score + " - " + home_score
      else
        result = nil
      end

      game_stats_hash[j][:date] = date.to_s
      game_stats_hash[j][:away] = away
      game_stats_hash[j][:home] = home
      game_stats_hash[j][:time] = time
      game_stats_hash[j][:result] = result
      game_stats_hash[j][:season] = "13-14"
      j += 1
    end

    add = Game.all.length

    game_stats_hash.each do |i, val|
      g = Game.find_by_id(i + add)
      if g
        g.update_attributes(val)
      else
        Game.create!(val)
      end
    end
  end
end
