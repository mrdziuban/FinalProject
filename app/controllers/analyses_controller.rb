class AnalysesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @analyses = Analysis.all
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

  def update
    @analysis = Analysis.find(params[:id])
    if @analysis.user != current_user
      render nothing: true
    else
      @analysis.update_attributes(params[:analysis])
      if request.xhr?
        render partial: "analysis", locals: {analysis: @analysis}
      end
    end
  end

  def destroy
    @analysis = Analysis.find(params[:id])
    if @analysis.user != current_user
      render nothing: true
    else
      @analysis.destroy
      redirect_to analyses_url
    end
  end

  def charts
  end
end