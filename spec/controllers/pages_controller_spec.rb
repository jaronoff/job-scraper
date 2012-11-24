require 'spec_helper'

describe PagesController do

  describe "GET 'home'" do
    it "returns http success" do
      get 'home'
      response.should be_success
      response.should render_template('home')
    end
  end

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
      response.should render_template('about')
    end
  end
  
  
  describe "GET scraper" do
    it 'get scraper is successful' do
      xhr :get, :scraper
      response.should be_success
      response.should render_template('scraper')
    end
  end

end
