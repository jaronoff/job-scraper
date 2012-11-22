class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  
 
  
  def email_rails_jobs(subject, message) 
    @subject = subject
    @message = message
    unless @message.empty? || @subject.empty?
      mail(to: "jasontanner328@gmail.com", subject: subject)
    end
  end
 
end
