class FavoritesController < ApplicationController
  def create
    Favorite.create!(user_id: current_user.id,
                     favoritable_id: params[:id],
                     favoritable_type: params[:type])
    render nothing: true
  end

  def destroy
    f = Favorite.where(user_id: current_user.id,
                       favoritable_id: params[:id],
                       favoritable_type: params[:type])[0]
    f.destroy
    render nothing: true
  end
end