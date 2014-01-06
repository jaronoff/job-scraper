class JobsController < ApplicationController
  respond_to :json

  def search
    render :json => Scraper.cl(params[:search_term])
    #render :json => [Job.new("city", "title", "link", "location", "1"), Job.new("city", "title something", "link", "location", "2")]
  end
end
