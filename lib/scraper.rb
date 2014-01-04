class Scraper
  def self.scrap_cl(search_term)
    require 'nokogiri'
    require 'open-uri'

    jobs = []

    time = Time.new - 10000

    month = I18n.t("date.abbr_month_names")[time.month]

    posts = []

    month = month.to_s

    cities = [
      "auburn", "bham", "tuscaloosa",
      "sfbay", "losangeles", "athensga", "phoenix", "santabarbara", "denver",
      "panamacity", "miami", "austin", "bakersfield", "keys", "newyork", "atlanta",
      "fortmyers", "orangecounty", "sandiego", "fresno", "sacramento", "savannah",
      "charleston", "lasvegas"
    ]

    cities.map do |city|

      search_terms = [search_term]

      search_terms.map do |term|
        urls = ["http://#{city}.craigslist.org/search/jjj?query=#{CGI.escape(term)}&catAbb=jjj&srchType=A&addOne=telecommuting"]

        #, "http://#{city}.craigslist.org/search/web?query=#{escaped_term}&catAbb=web&srchType=A&zoomToPosting="

        urls.map do |url|
          doc = Nokogiri::HTML(open(url))

          doc.css(".row").map do |row|

            date = row.css(".itemdate").text

            location = row.css(".itempn").text.to_s[2..-2]

            a_tag = row.css("a")[0]

            text = a_tag.text

            link = a_tag[:href]

            jobs << Job.new(city.capitalize, text, link, location) if date.include? month
          end
        end
      end
    end
  end
end