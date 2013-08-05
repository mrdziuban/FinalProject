require 'open-uri'

class Goalie < ActiveRecord::Base
  attr_accessible :age, :ga, :gaa, :gp, :l, :min, :name, :otl, :sa, :shutouts, :sv, :sv_perc, :team_abbrev, :w

  belongs_to :team, foreign_key: "team_abbrev", primary_key: "abbrev"



  def self.scrape
    goalie_stats_url = "http://www.hockey-reference.com/leagues/NHL_2013_goalies.html"
    goalie_stats_page = Nokogiri::HTML(open(goalie_stats_url))
    goalie_stats_table = goalie_stats_page.css("#stats")
    goalie_stats_hash = {}
    keys = [:age, :team_abbrev, :gp, :w, :l, :otl, :ga, :sa, :sv, :sv_perc, :gaa,
            :shutouts, :min]

    goalie_stats_table.css("tr").each_with_index do |tr, i|
      next if tr.css("td").length == 0
      goalie = tr.css("td")[1].css("a").text.strip
      goalie_stats_hash[goalie] = {}

      goalie_stats = []
      tr.css("td").each_with_index do |td, i|
        next if [0,1,15,16,17,18].include?(i)

        stat = td.text.strip

        if i == 3
          goalie_stats << stat
        elsif i == 11 || i == 12
          goalie_stats << stat.to_f
        else
          goalie_stats << stat.to_i
        end
      end

      goalie_stats.each_with_index do |gs, i|
        gs = "LOS" if gs == "LAK"
        gs = "MON" if gs == "MTL"
        gs = "WAS" if gs == "WSH"
        gs = "PHO" if gs == "PHX"
        gs = "TAM" if gs == "TBL"
        goalie_stats_hash[goalie][keys[i]] = gs
      end
    end

    i = 1
    add = Goalie.all.length

    goalie_stats_hash.each do |name, val|
      g = Goalie.find_by_id(i + add)
      if g
        g.update_attributes(val)
        g.name = name
        g.save
      else
        g = Goalie.new(val)
        g.name = name
        g.save
      end
      i += 1
    end
  end
end
