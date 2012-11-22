desc "Fetch rails jobs"
  task :rails_jobs => :environment do

  require 'rubygems'
  require 'nokogiri'
  require 'open-uri'
  
  time = Time.new
  month = I18n.t("date.abbr_month_names")[time.month]
  day = time.day
  
  
  #United States
  cities = [
    "sfbay", "losangeles", "athensga", "phoenix", "santabarbara", "denver",
    "panamacity", "miami", "austin", "bakersfield", "keys", "newyork"
  ]
  
  #Search Terms
  terms = ["ruby on rails", "rails", "junior rails", "rails developer"]
  
  terms.each do |term|  
    escaped_search_term = CGI.escape(term)
    cities.each do |city|
      url = "http://#{city}.craigslist.org/search/jjj?query=#{escaped_search_term}&catAbb=jjj&srchType=A"
      doc = Nokogiri::HTML(open(url))
      doc.css(".row").each do |row|
        if row.at_css(".itemdate").text == "#{month} #{day}"
          link = row.css("a")[0][:href]
          description = row.at_css("a")[0].text
          puts "#{description} can be found at #{link}"
        end
      end
    end
  end

end
