class PlayerFavoritesController < ApplicationController
  def create
    PlayerFavorite.create!(player_id: params[:player_id], user_id: current_user.id)
    render nothing: true
  end

  def destroy
    pf = PlayerFavorite.find_by_player_id_and_user_id(params[:player_id], current_user.id)
    pf.destroy
    render nothing: true
  end
end