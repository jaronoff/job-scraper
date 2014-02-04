class Job
  attr_accessor :city, :title, :url, :location, :date, :type

  def initialize(city, title, url, location, date, type, date_as_i)
    @city = city
    @title = title
    @url = url
    @location = location
    @date = date
    @type = type
    @date_as_i = date_as_i
  end
end
