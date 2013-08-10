require 'open-uri'

class Team < ActiveRecord::Base
  include PgSearch
  attr_accessible :abbrev, :background, :background_color, :faceoff_perc, :gapg, :gp, :gpg, :losses, :name, :ot_losses, :pk_perc, :players_pic, :point_perc, :points, :pp_perc, :sapg, :spg, :wins

  has_attached_file :background, styles: {icon: "39x22", medium: "222x125"}
  has_attached_file :players_pic, styles: {original: "222x125"}
  has_many :players, foreign_key: "team_abbrev", primary_key: "abbrev"
  has_many :goalies, class_name: "Goalie", foreign_key: "team_abbrev", primary_key: "abbrev"
  has_many :home_games, class_name: "Game", foreign_key: "home", primary_key: "abbrev"
  has_many :away_games, class_name: "Game", foreign_key: "away", primary_key: "abbrev"
  has_many :favorites, foreign_key: :favoritable_id, conditions: {favoritable_type: "Team"}, dependent: :destroy
  has_many :users, through: :favorites
  multisearchable against: [:name]

  def to_param
    abbrev
  end

  def games
    (self.home_games + self.away_games).sort_by &:date
  end

  def recent_and_upcoming_games
    next_3 = self.games.select {|g| g.date >= Date.today}[0..2]
    last_3 = self.games.select {|g| g.date < Date.today}[-3..-1]
    last_3 + next_3
  end



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

  TEAM_NAMES = {
    :BOS => "Boston Bruins",
    :BUF => "Buffalo Sabres",
    :CGY => "Calgary Flames",
    :CHI => "Chicago Blackhawks",
    :DET => "Detroit Red Wings",
    :EDM => "Edmonton Oilers",
    :CAR => "Carolina Hurricanes",
    :LOS => "Los Angeles Kings",
    :MON => "Montreal Canadiens",
    :DAL => "Dallas Stars",
    :NJD => "New Jersey Devils",
    :NYI => "New York Islanders",
    :NYR => "New York Rangers",
    :PHI => "Philadelphia Flyers",
    :PIT => "Pittsburgh Penguins",
    :COL => "Colorado Avalanche",
    :STL => "St. Louis Blues",
    :TOR => "Toronto Maple Leafs",
    :VAN => "Vancouver Canucks",
    :WAS => "Washington Capitals",
    :PHO => "Phoenix Coyotes",
    :SJS => "San Jose Sharks",
    :OTT => "Ottawa Senators",
    :TAM => "Tampa Bay Lightning",
    :ANA => "Anaheim Ducks",
    :FLA => "Florida Panthers",
    :WPG => "Winnipeg Jets",
    :CBJ => "Columbus Blue Jackets",
    :MIN => "Minnesota Wild",
    :NSH => "Nashville Predators"
  }

  BACKGROUND_COLORS = {
    :BOS => "#E3A228",
    :BUF => "#173458",
    :CGY => "#BF393E",
    :CHI => "#A83632",
    :DET => "#A93632",
    :EDM => "#0B2343",
    :CAR => "#CC171E",
    :LOS => "#513789",
    :MON => "#B21F24",
    :DAL => "#0C6F4C",
    :NJD => "#BD141B",
    :NYI => "#F0713E",
    :NYR => "#10337C",
    :PHI => "#E85B31",
    :PIT => "#F4B74B",
    :COL => "#8B2842",
    :STL => "#2F5D8D",
    :TOR => "#20416A",
    :VAN => "#00693F",
    :WAS => "#E31C38",
    :PHO => "#890F11",
    :SJS => "#3E7E86",
    :TAM => "#11477A",
    :ANA => "#DF4531",
    :FLA => "#E01A22",
    :WPG => "#2C2A77",
    :CBJ => "#173151",
    :MIN => "#005838",
    :NSH => "#0D2344",
    :OTT => "#A93632"
  }

  def self.scrape
    team_stats_url = "http://www.nhl.com/ice/teamstats.htm?season=20122013&gameType=2&viewName=summary#?navid=nav-sts-teams"
    team_stats_page = Nokogiri::HTML(open(team_stats_url))
    team_stats_table = team_stats_page.css(".data.stats")
    team_stats_hash = {}
    keys = [:gp, :wins, :losses, :ot_losses, :points, :point_perc, :gpg, :gapg,
            :pp_perc, :pk_perc, :spg, :sapg, :faceoff_perc]

    team_stats_table.css("tr").each_with_index do |tr, i|
      next if i == 0 || i == 1
      team = tr.css("td")[1].text.strip
      if team == "ST LOUIS"
        team = "st. louis"
      end
      team = TEAM_ABBREVS[team.downcase]
      team_stats_hash[team] = {}

      team_stats = []

      (2..21).each do |i|
        next if i == 10 || i.between?(15, 20)
        if i.between?(2,6)
          team_stats << tr.css("td")[i].text.strip.to_i
        else
          team_stats << tr.css("td")[i].text.strip.to_f
        end
      end

      keys.each_with_index do |key, i|
        team_stats_hash[team][key] = team_stats[i]
      end
    end

    i = 1

    team_stats_hash.each do |abbrev, val|
      puts abbrev
      puts val
      t = Team.find_by_id(i)
      if t
        t.update_attributes(val)
        t.abbrev = abbrev
        t.name = TEAM_NAMES[abbrev]
        t.background_color = BACKGROUND_COLORS[abbrev]
        t.save
      else
        t = Team.new(val)
        t.abbrev = abbrev
        t.name = TEAM_NAMES[abbrev]
        t.background_color = BACKGROUND_COLORS[abbrev]
        t.save
      end
      i += 1
    end
  end

  def self.populate_backgrounds
    Team.all.each do |team|
      name_words = team.name.split(" ")
      if ["New York Rangers", "New York Islanders", "Los Angeles Kings", "New Jersey Devils", "St. Louis Blues", "Tampa Bay Lightning", "San Jose Sharks"].include?(team.name)
        file_name = "#{name_words[-1].downcase}.jpg"
      elsif name_words.length == 3
        file_name = "#{name_words[1..2].join('_').downcase}.jpg"
      else
        file_name = "#{name_words[-1].downcase}.jpg"
      end
      
      team.background = File.new("lib/team_backgrounds/#{file_name}", "r")
      team.save
    end
  end

  def self.populate_players_pics
    Team.all.each do |team|
      name_words = team.name.split(" ")

      if ["New York Rangers", "New York Islanders", "Los Angeles Kings", "New Jersey Devils", "St. Louis Blues", "Tampa Bay Lightning", "San Jose Sharks"].include?(team.name)
        file_name = "#{name_words[-1].downcase}.jpg"
      elsif name_words.length == 3
        file_name = "#{name_words[1..2].join('_').downcase}.jpg"
      else
        file_name = "#{name_words[-1].downcase}.jpg"
      end

      team.players_pic = File.new("lib/players_pics/#{file_name}", "r")
      team.save
    end
  end

  def self.scrape_standings
    standings_url = "http://www.nhl.com/ice/standings.htm?type=DIV#&navid=nav-stn-div"
    standings_page = Nokogiri::HTML(open(standings_url))
    standings_tables = standings_page.css(".data.standings.Division")
    standings_hash = {}

    standings_tables.each do |t|
      division = (t.css("th")[1].text).to_sym
      standings_hash[division] = {}
      t.css("tbody tr").each do |tr|
        team = (tr.css("a")[1].text).strip
        team = I18n.transliterate(team)
        team = TEAM_ABBREVS[team.downcase]
        standings_hash[division][team] = {}
        (2..15).each do |i|
          key = t.css("th")[i].css("a").text.strip
          if key == "S/O"
            key = "SO"
          end
          if i.between?(2,9)
            val = tr.css("td")[i].text.strip.to_i
          else
            val = tr.css("td")[i].text.strip
          end
          standings_hash[division][team][key.to_sym] = val
        end
      end
    end

    return standings_hash
  end

  @@standings = Team.scrape_standings

  def self.standings
    @@standings
  end

  def luminance(lum)
    hex = self.background_color.gsub(/[^0-9a-fA-F]/, '');
    if hex.length < 6
      hex = "#{hex[0]}#{hex[0]}#{hex[1]}#{hex[1]}#{hex[2]}#{hex[2]}"
    end

    rgb = "#"
    3.times do |i|
      c = hex[(i*2)...(i*2 + 2)].to_i(16)
      x = [0, c + (c * lum)].max
      y = [x, 255].min
      c = y.round.to_s(16)
      rgb += "00#{c}"[(c.length)..-1]
    end

    rgb
  end
end
