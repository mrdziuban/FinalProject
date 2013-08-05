class PlayersController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @player = Player.find(params[:id])
  end
end