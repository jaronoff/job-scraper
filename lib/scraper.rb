class Scraper
  def self.cl(search_term)
    jobs = []

    time = Time.new - 10000

    month = I18n.t("date.abbr_month_names")[time.month]

    current_month = month.to_s

    cities = ["auburn", "bham", "tuscaloosa", "sfbay", "losangeles", "athensga",
              "phoenix", "santabarbara", "denver", "panamacity", "miami", "austin",
              "bakersfield", "keys", "newyork", "atlanta", "fortmyers", "orangecounty",
              "sandiego", "fresno", "sacramento", "savannah", "charleston", "lasvegas"
    ]

    cities.each do |city|
      search_terms = search_term.split(" ") << search_term

      search_terms.map do |term|

        escaped_term = CGI.escape(term)

        urls = ["http://#{city}.craigslist.org/search/jjj?query=#{escaped_term}&catAbb=jjj&srchType=A&addOne=telecommuting",
                "http://#{city}.craigslist.org/search/cpg?query=#{escaped_term}&zoomToPosting=&addThree="
        ]

        urls.each do |url|
          doc = Nokogiri::HTML(open(url))

          doc.css(".row").map do |row|
            date = row.css(".date").text

            location = row.css(".pnr").text.to_s[2..-2]

            a_tag = row.css("a")[1]

            text = row.css("a")[1].text

            link = a_tag[:href]

            if date.include? current_month
              post_date = date.split(" ")

              month = Date::ABBR_MONTHNAMES.index(post_date[0])

              job_date = DateTime.new(DateTime.now.year, month.to_i, post_date[1].to_i)

              job_location = city.capitalize

              job_title = text

              split_link = link.split("/")

              if split_link.count > 2
                job_url = "http://#{city}.craigslist.org" + "/" + split_link[-2..-1].join("/")
              else
                job_url = "http://#{city}.craigslist.org" + "/" + split_link.join("/")
              end

              jobs << Job.new(city, job_title, job_url, job_location, date) if job_title.present?
            end
          end
        end
      end
    end

    return jobs
  end
end