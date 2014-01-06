class JobsController < ApplicationController
  respond_to :json

  def search
    render :json => Scraper.cl(params[:search_term])
    #render :json => [Job.new("city", "title", "link", "location", "date"), Job.new("city", "title something", "link", "location", "date")]
  end
end
