require 'open-uri'

class Player < ActiveRecord::Base
  attr_accessible :a, :blocks, :fo_perc, :g, :gp, :hits, :image, :name, :pim, :plus_minus, :ppg, :pts, :shot_perc, :shots, :team_abbrev

  has_attached_file :image, styles: {original: "65x90"}
  belongs_to :team, foreign_key: "team_abbrev", primary_key: "abbrev"
  has_many :player_favorites
  has_many :users, through: :player_favorites



  def self.scrape
    player_stats_url = "http://sports.yahoo.com/nhl/stats/byposition?pos=C,RW,LW,D&conference=NHL&year=season_2012&qualified=1"
    player_stats_page = Nokogiri::HTML(open(player_stats_url))
    player_stats_table = player_stats_page.css("table.yspcontent")
    player_stats_hash = {}

    keys = [:team_abbrev, :gp, :g, :a, :pts, :plus_minus, :pim, :hits, :blocks,
            :fo_perc, :ppg, :shots, :shot_perc]

    player_stats_table.css(".ysprow1, .ysprow2").each do |p|
      player = p.css("td")[0].text.strip[1..-1]
      player_stats_hash[player] = {}

      player_stats = []

      p.css("td").each_with_index do |td, i|
        skips = (3..37).step(2).to_a
        skips += [18, 20, 26, 28, 30, 32]
        next if i == 0 || skips.include?(i)
        if i == 1
          team = td.text.strip
          if team == "COB"
            team = "CBJ"
          end
          if team == "NAS"
            team = "NSH"
          end
          player_stats << team
        elsif i.between?(2,20) || i.between?(24,34)
          player_stats << td.text.strip.to_i
        else
          player_stats << td.text.strip.to_f
        end
      end

      keys.each_with_index do |key, i|
        player_stats_hash[player][key] = player_stats[i]
      end
    end

    player_stats_hash = Hash[player_stats_hash.sort_by {|p,v| p.split(" ")[1].downcase}]

    id = 1
    player_stats_hash.each do |k, v|
      v[:id] = id
      id += 1
    end

    player_stats_hash.each do |name, val|
      p = Player.find_by_id(val[:id])
      val.delete(:id)
      if p
        p.update_attributes(val)
        p.name = name
        p.save
      else
        p = Player.new(val)
        p.name = name
        p.save
      end
    end
  end

  def self.scrape_images
    Player.all.each do |player|
      begin
        name = player.name.split(" ").join("-")
        url = "http://search.espn.go.com/#{name}"
        page = Nokogiri::HTML(open(url))
        img = page.at(".span-5 > .col-results > ol > li.result.mod-smart-card > div.card-img > a > img")
        next if img.nil?
        src = img["src"]
        File.open("lib/player_profile_pics/#{name}.png", "wb") do |f|
          f.write(open(src).read)
        end
      rescue OpenURI::HTTPError
        next
      end
    end
  end

  def self.populate_images
    Player.all.each do |player|
      name = player.name.split(" ").join("-")
      if File.file?("lib/player_profile_pics/#{name}.png")
        player.image = File.open("lib/player_profile_pics/#{name}.png", "r")
        player.save
      end
    end
  end
end
