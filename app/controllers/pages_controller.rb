class PagesController < ApplicationController
  
  def home
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def about   
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end  

  def jobs
    month = params[:month]
    day = params[:day]
    scrap_cl(month, day)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  
  def mail
    unless params[:to].empty? 
      @posts = scrap_cl
      if UserMailer.email_rails_jobs(@posts, params[:to]).deliver 
        flash[:success] = "Email Sent!"
      else
        flash[:error] = "Email was not sent!"
      end
    else
      flash[:error] = "Please fill in your email!"
    end

    redirect_to home_path
  end
  
  
  
private 



    def scrap_cl(month, day)


      require 'nokogiri'
      require 'open-uri'
                 
      time = Time.new - 10000
      month = I18n.t("date.abbr_month_names")[time.month]
      day = time.day
      @posts = []
      @time = month + day
      
      cities = [
        "sfbay", "losangeles"
      ]
      
      #, "athensga", "phoenix", "santabarbara", "denver",
       # "panamacity", "miami", "austin", "bakersfield", "keys", "newyork", "atlanta",
        #"fortmyers", "orangecounty", "sandiego", "fresno", "sacramento", "savannah",
        #"charleston", "lasvegas"
          
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
                            
            if date.include? @time
            
              @posts << "<tr><td>#{city.capitalize}</td>"
                              
              @posts << "<td>#{text}</td>"
                              
              @posts << "<td><a href='#{link}'>Link</a></td>"
                              
              @posts << "<td>#{location}</td>"
                              
              @posts << "</tr>"
              

                                                      
            end
                    
          end
              
        end
              
      end

    end


end
