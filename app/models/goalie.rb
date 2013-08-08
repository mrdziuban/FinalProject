require 'open-uri'

class Goalie < ActiveRecord::Base
  attr_accessible :age, :ga, :gaa, :gp, :image, :l, :min, :name, :otl, :sa, :shutouts, :sv, :sv_perc, :team_abbrev, :w

  has_attached_file :image, styles: {original: "65x90"}
  belongs_to :team, foreign_key: "team_abbrev", primary_key: "abbrev"
  has_many :favorites, foreign_key: :favoritable_id, conditions: {favoritable_type: "Goalie"}, dependent: :destroy
  has_many :users, through: :favorites



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

  def self.scrape_images
    Goalie.all.each do |goalie|
      begin
        name = goalie.name.split(" ").join("-")
        url = "http://search.espn.go.com/#{name}"
        page = Nokogiri::HTML(open(url))
        img = page.at(".span-5 > .col-results > ol > li.result.mod-smart-card > div.card-img > a > img")
        next if img.nil?
        src = img["src"]
        File.open("lib/goalie_profile_pics/#{name}.png", "wb") do |f|
          f.write(open(src).read)
        end
      rescue OpenURI::HTTPError
        next
      end
    end

    # Delete the default "no photo" image based on file size
    Dir.foreach("lib/goalie_profile_pics") do |f|
      if File.size("lib/goalie_profile_pics/#{f}") == 2422
        File.delete("lib/goalie_profile_pics/#{f}")
      end
    end
  end

  def self.populate_images
    Goalie.all.each do |goalie|
      name = goalie.name.split(" ").join("-")
      if File.file?("lib/goalie_profile_pics/#{name}.png")
        goalie.image = File.open("lib/goalie_profile_pics/#{name}.png", "r")
        goalie.save
      end
    end
  end
end
