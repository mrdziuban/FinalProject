class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index

  end

  def search
    @results = PgSearch.multisearch(params[:query])
    if request.xhr?
      render partial: "results", locals: {results: @results, query: params[:query]}
    end
  end
end