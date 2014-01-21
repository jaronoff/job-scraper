class Scraper
  require 'nokogiri'
  require 'open-uri'

  def self.cl(search_term)
    jobs = []

    # Craigslist
    # ==========
=begin
    time = Time.new - 10000

    month = I18n.t("date.abbr_month_names")[time.month]

    current_month = month.to_s

    cities = {}

    urls = []

    Nokogiri::HTML(open("http://craigslist.org", 'User-Agent' => 'ruby')).css(".box").each do |box|
      box.css("a").each do |a|
        if a["href"][-3..-1] == "org"

          cities[a.text] = a["href"].split(".").first.split('/').last
        end
      end
    end

    cities.each do |proper_city_name, city|
      search_terms = search_term.split(" ") << search_term

      search_terms.map do |term|

        escaped_term = CGI.escape(term)

        urls = ["http://#{city}.craigslist.org/search/jjj?query=#{escaped_term}&catAbb=jjj&srchType=A&addOne=telecommuting",
                "http://#{city}.craigslist.org/search/cpg?query=#{escaped_term}&zoomToPosting=&addThree="
        ]


        urls.each do |url|
          doc = Nokogiri::HTML(open(url, 'User-Agent' => 'ruby'))

          doc.css(".row").map do |row|
            puts "well it works"

            date = row.css(".date").text

            location = row.css(".pnr").text.to_s[2..-2]

            a_tag = row.css("a")[1]

            text = a_tag.text

            link = a_tag[:href]


            if date.include? current_month
              post_date = date.split(" ")

              month = Date::ABBR_MONTHNAMES.index(post_date[0])

              job_date = DateTime.new(DateTime.now.year, month.to_i, post_date[1].to_i)

              job_title = text

              url[-1] == "g" ? type = "Telecommute" : type = "Gig"

              if job_title.present?
                selected = jobs.select{ |job| job.url == link }

                if selected.blank?
                  jobs << Job.new(city, job_title, link, proper_city_name.capitalize, date, type)
                end
              end
            end
          end
        end
      end
    end
=end
    # We Work Remotely
    # =================
    escaped_term = CGI.escape(search_term)

    doc = Nokogiri::HTML(open("https://weworkremotely.com/jobs/search?term=#{escaped_term}", 'User-Agent' => 'ruby'))

    doc.css('.jobs').each do |jobs_box|
      jobs_box.css("li").each do |job|
        if job.css("a")[0][:class] != "view-all"
          company = job.css(".company").text

          title = job.css(".title").text

          date = job.css(".date").text

          link = "https://weworkremotely.com" + job.css("a")[0][:href]

          jobs << Job.new("Your Home", title, link, "Your Home", date, "Telecommute")
        end
      end
    end

    # Dice.com
    # =========
    escaped_term = CGI.escape(search_term)

    doc = Nokogiri::HTML(open("http://www.dice.com/job/results/programming?b=7&caller=searchagain&q=#{escaped_term}&src=19&u=1&x=all&p=k"))

    doc.css('.summary').first.css('tbody').first.css('tr').each do |tr|
      td = tr.css('td')

      if td.first and td.first.css('div')
        embedded_div = td.first.css('div')

        if embedded_div.first and embedded_div.first.css('a')
          a_tag = embedded_div.first.css('a')

          date = td.last.text.split("-")

          date.pop

          jobs << Job.new("Your home", a_tag.first.text, "http://www.dice.com" + a_tag.first[:href], "Your Home", date.join(' '), "Telecommute")
        end
      end
    end

    return jobs
  end
end
