class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  
 
  
  def email_rails_jobs(posts, to) 
    
    @posts = posts
    @to = to
    unless @posts.empty? || @to.empty?
      mail(to: to, subject: "Rails Jobs for #{Time.now}")
    end
  end
 
end
