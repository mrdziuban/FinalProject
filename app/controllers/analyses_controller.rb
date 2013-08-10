class AnalysesController < ApplicationController
  def index
    @analyses = Analysis.page(params[:page]).per(50)
  end

  def new
    @analysis = Analysis.new
  end

  def create
    @analysis = Analysis.new(params[:analysis])
    @analysis.user_id = current_user.id
    @analysis.save
    if request.xhr?
      render partial: "analyses", locals: {analyses: Analysis.all}
    end
  end

  def show
    @analysis = Analysis.find(params[:id])
  end

  def edit
    @analysis = Analysis.find(params[:id])
  end

  def update
    @analysis = Analysis.find(params[:id])
    if @analysis.update_attributes(params[:analysis])
      redirect_to analysis_url(@analysis)
    else
      render :edit
    end
  end

  def destroy
    @analysis = Analysis.find(params[:id])
    @analysis.destroy
  end
end