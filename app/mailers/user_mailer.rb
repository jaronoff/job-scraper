class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  
 
  
  def email_rails_jobs(subject, message, to) 
    @subject = subject
    @message = message
    @to = to
    unless @message.empty? || @subject.empty? || @to.empty?
      mail(to: to, subject: subject)
    end
  end
 
end
