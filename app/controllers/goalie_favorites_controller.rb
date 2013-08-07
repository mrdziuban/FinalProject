class GoalieFavoritesController < ApplicationController
  def create
    GoalieFavorite.create!(goalie_id: params[:goalie_id], user_id: current_user.id)
    render nothing: true
  end

  def destroy
    gf = GoalieFavorite.find_by_goalie_id_and_user_id(params[:goalie_id], current_user.id)
    gf.destroy
    render nothing: true
  end
end