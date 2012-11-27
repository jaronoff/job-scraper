class PagesController < ApplicationController

  def home
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def about
    
    scrap_cl
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
    

  end
  
  def scraper
    respond_to do |format|
      format.js 
    end
  end
  
  private 
  
    def scrap_cl

      require 'rubygems'
      require 'nokogiri'
      require 'open-uri'
                 
      time = Time.new
      month = I18n.t("date.abbr_month_names")[time.month]
      day = time.day
      @strings = []
      
          
      cities = [
        "sfbay", "losangeles", "athensga", "phoenix", "santabarbara", "denver",
        "panamacity", "miami", "austin", "bakersfield", "keys", "newyork"
      ]
          
      cities.map do |city|

        search_terms = ["ruby on rails", "rails", "ruby"]
          
        search_terms.map do |term|
          
          escaped_term = CGI.escape(term)
          
          url = "http://#{city}.craigslist.org/search/jjj?query=#{escaped_term}&catAbb=jjj&srchType=A"
           
          doc = Nokogiri::HTML(open(url))
                
              doc.css(".row").map do |row|
                  
                date = row.css(".itemdate").text
                    
                a_tag = row.css("a")[0]
              
                text = a_tag.text
              
                link = a_tag[:href]
                
                if date.include? "#{month} #{day}" 
   
                  @strings << "#{date} #{text} <a href='#{link}'>Link</a>"
   
                end
            
             end
          
          end
          
       end
          
      end

    end
