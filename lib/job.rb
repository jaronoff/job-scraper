class Job
  attr_accessor :city, :title, :url, :location, :date, :type

  def initialize(city, title, url, location, date, type)
    @city = city
    @title = title
    @url = url
    @location = location
    @date = date
    @type = type
  end
end
