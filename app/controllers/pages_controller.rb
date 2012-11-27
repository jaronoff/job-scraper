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
      @posts = []
      
          
      cities = [
        "sfbay", "losangeles", "athensga", "phoenix", "santabarbara", "denver",
        "panamacity", "miami", "austin", "bakersfield", "keys", "newyork", "atlanta",
        "fortmyers", "orangecounty", "sandiego", "fresno", "sacramento", "savannah",
        "charleston", "lasvegas"
      ]
          
      cities.map do |city|

           search_terms = ["ruby on rails", "rails", "ruby", "angularjs", "angular js"]
              
           search_terms.map do |term|
              
                      escaped_term = CGI.escape(term)
                      
                      url = "http://#{city}.craigslist.org/search/jjj?query=#{escaped_term}&catAbb=jjj&srchType=A"
                       
                      doc = Nokogiri::HTML(open(url))
                            
                      doc.css(".row").map do |row|
                          
                            date = row.css(".itemdate").text
                            
                            location = row.css(".itempn").text.to_s[2..-2]    
                                
                            a_tag = row.css("a")[0]
                          
                            text = a_tag.text
                          
                            link = a_tag[:href]
                            
                            if date.include? "Nov 23"
            
                              @posts << "<tr><td>#{date}</td><td>#{text}</td><td><a href='#{link}'>Link</a></td><td>#{location}</td><td><button class='btn btn-success'>Job Added</button></td></tr>"
               
                            end
                    
                     end
              
           end
              
      end
               

    end


end
