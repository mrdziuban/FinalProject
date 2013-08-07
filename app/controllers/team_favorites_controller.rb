class TeamFavoritesController < ApplicationController
  def create
    TeamFavorite.create!(team_abbrev: params[:team_id], user_id: current_user.id)
    render nothing: true
  end

  def destroy
    tf = TeamFavorite.find_by_team_abbrev_and_user_id(params[:team_id], current_user.id)
    tf.destroy
    render nothing: true
  end
end