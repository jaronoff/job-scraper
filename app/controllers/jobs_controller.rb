class JobsController < ApplicationController
  def search
    render :json => Scraper.scrap_cl(params[:search_term])
  end
end
