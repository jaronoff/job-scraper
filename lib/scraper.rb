class Scraper
  require 'nokogiri'
  require 'open-uri'

  @@months = { "Jan" => 1, "Feb" => 2, "Nov" => 11, "Dec" => 12 }

  def self.cl(search_term)
    jobs = []

    # Craigslist
    # ==========
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
            date = row.css(".date").text

            location = row.css(".pnr").text.to_s[2..-2]

            a_tag = row.css("a")[1]

            text = a_tag.text

            link = a_tag[:href]

            if link[0] != "h"
              link = "http://#{city}.craigslist.org" + link
            end

            if date.include? current_month
              post_date = date.split(" ")

              month = Date::ABBR_MONTHNAMES.index(post_date[0])

              job_date = DateTime.new(DateTime.now.year, month.to_i, post_date[1].to_i)

              job_title = text

              url[-1] == "g" ? type = "Telecommute" : type = "Gig"

              if job_title.present?
                selected = jobs.select do |job|
                  check_one = job.url == link

                  job_title.length >= 15 ? check_two = job.title[0..15] == job_title[0..15] : check_two = false

                  check_one or check_two
                end

                if selected.blank?
                  puts post_date.inspect

                  date_as_i = (@@months[post_date.first] * 100) + post_date.last.to_i

                  jobs << Job.new(city, job_title, link, proper_city_name.capitalize, date, type, date_as_i)
                end
              end
            end
          end
        end
      end
    end

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

          split_date = date.split(" ")

          date_as_i = (@@months[split_date.first] * 100) + split_date.last.to_i

          jobs << Job.new("Your Home", title, link, "Your Home", date, "Telecommute", date_as_i)
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

          split_date = date

          date = date.join(' ')

          date_as_i = (@@months[split_date.first] * 100) + split_date.last.to_i

          jobs << Job.new("Your home", a_tag.first.text, "http://www.dice.com" + a_tag.first[:href], "Your Home", date, "Telecommute", date_as_i)
        end
      end
    end

    # Hire There
    # ==========
    escaped_term = CGI.escape(search_term)

    doc = Nokogiri::HTML(open("https://hirethere.com/jobs/search?search=#{escaped_term}"))

    doc.css('#jobList').css('li').each do |li|

      link = "https://hirethere.com" + li.css('a').first[:href]

      title = li.css('a').first.css('h5').first.text

      date = li.css('a').first.css('p').last.css('time').first[:datetime]

      date = date.split(" ")[1..3]

      date_as_i = (@@months[date[1]].to_i * 100) + date[0].to_i

      date = date[1] + " " + date[0]

      if date_as_i < ((Time.now.month * 100) + 100)
        jobs << Job.new("Your Home", title, link, "Your Home", date, "Telecommute", date_as_i)
      end
    end

    # Top Ruby Jobs
    # =============
    doc = Nokogiri::HTML(open("https://toprubyjobs.com/jobs?utf8=%E2%9C%93&filter%5B%5D=contract&filter%5B%5D=freelance&filter%5B%5D=remote&q="))

    doc.css('#jobs').first.css('.job').each do |job|
      title = job.css('h4').first.text

      link = "https://toprubyjobs.com" + job.css('h4').first.css('a').first[:href]

      date = "Recently"

      date_as_i = (Time.now.month * 100) + Time.now.day

      jobs << Job.new("Your Home", title, link, "Your Home", date, "Telecommute", date_as_i)
    end

    # Rubyjobs.io
    # ===========
    doc = Nokogiri::HTML(open("http://rubyjobs.io/"))

    doc.css('.jobs').first.css('tbody').first.css('.job').each do |job|
      title = job.css('.title').first.text

      link = 'http://rubyjobs.io/' + job.css('.title').first.css('a').first[:href]

      location = job.css('.location').first.text

      date = job.css('.date').first.css('em').first[:title][0..9].split('-')

      date_as_i = (date[1].to_i * 100) + date[2].to_i

      date = @@months.key(date[1].to_i) + " " + date[2]

      city = location.split(',').first

      jobs << Job.new(city, title, link, location, date, "Telecommute", date_as_i)
    end

    return jobs
  end
end
