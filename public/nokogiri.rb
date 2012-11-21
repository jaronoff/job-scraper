require 'rubygems'
require 'nokogiri'
require 'openuri'

url = "http://losangeles.craigslist.org/search/jjj?query=ruby+on+rails&catAbb=jjj&srchType=A"
doc = Nokogiri::HTML(open(url))
puts doc.at_css('title').text
puts.css("grab selector from cl...")
