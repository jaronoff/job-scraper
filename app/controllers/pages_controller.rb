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
    if scrap_cl().empty?
      flash[:error] = "Nothing found this month!"
      redirect_to home_path
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @posts }
      end
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



    def scrap_cl()


      require 'nokogiri'
      require 'open-uri'
                 
      time = Time.new - 10000
      month = I18n.t("date.abbr_month_names")[time.month]

      @posts = []
      @time = month.to_s
      
      cities = [
        "auburn", "bham", "tuscaloosa", 
        "sfbay", "losangeles", "athensga", "phoenix", "santabarbara", "denver",
        "panamacity", "miami", "austin", "bakersfield", "keys", "newyork", "atlanta",
        "fortmyers", "orangecounty", "sandiego", "fresno", "sacramento", "savannah",
        "charleston", "lasvegas"
      ]
          
      cities.map do |city|

        search_terms = ["ruby"]
              
        search_terms.map do |term|
              
          escaped_term = CGI.escape(term)
                   
          urls = ["http://#{city}.craigslist.org/search/jjj?query=#{escaped_term}&catAbb=jjj&srchType=A&addOne=telecommuting"]

          #, "http://#{city}.craigslist.org/search/web?query=#{escaped_term}&catAbb=web&srchType=A&zoomToPosting="

          urls.map do |url|

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


end
