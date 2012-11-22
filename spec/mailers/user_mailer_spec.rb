require "spec_helper"

describe UserMailer do
  
  
  
 describe "with success" do 
  
   before do
    @subject = "Hello"
    @message = "Test message"
    @email = UserMailer.email_rails_jobs(@subject, @message).deliver
   end

  it "should include email to" do
     @email.to.should include("jasontanner328@gmail.com")   
  end
  
  it "should include email subject" do
     @email.subject.should eq(@subject)   
  end
  
  it "should include email message" do
     @email.encoded.should include(@message)
  end
 
  
  it "should be added to the delivery queue" do
     lambda { UserMailer.email_rails_jobs(@subject, @message).deliver }.should change(ActionMailer::Base.deliveries,:size).by(1) 
  end
  
  it "should render successfully" do
     lambda { @email }.should_not raise_error
  end
  
 end
  
 describe "with empty message" do
  
    before do
      @subject = "hello"
      @message = ""
      @email = UserMailer.email_rails_jobs(@subject, @message,).deliver
    end
  
    it "should include email to" do
       @email.should be_nil   
    end
  
    
    it "should not be added to the delivery queue" do
       lambda { UserMailer.email_rails_jobs(@subject, @message).deliver }.should change(ActionMailer::Base.deliveries,:size).by(0) 
    end

   
 end
 

 describe "with empty subject" do
  
    before do
      @subject = ""
      @message = "asdf"
      @email = UserMailer.email_rails_jobs(@subject, @message).deliver
    end
  
    it "should include email to" do
       @email.should be_nil   
    end
  
    
    it "should not be added to the delivery queue" do
       lambda { UserMailer.email_rails_jobs(@subject, @message).deliver }.should change(ActionMailer::Base.deliveries,:size).by(0) 
    end

   
 end  
  
  
  
  
end
