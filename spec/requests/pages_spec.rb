require 'spec_helper'

describe "Pages" do

  describe "home page" do
  
    subject { page }
    
    before :each do
      visit home_path
    end
        
    it "" do
  
       should have_selector("h1", text: "Welcome to Super CraigsList Rails Jobs Finder")
  
    end
    
    context "user filled everything out correctly" do
    
      it "email sent" do
       
        fill_in "to", with: "jasontanner328@gmail.com"
       
        expect do   
          click_button "Get Ya Jobs"      
        end.to change(ActionMailer::Base.deliveries,:size).by(1)
      
      end
    
      it "alert is shown" do
       
        fill_in "to", with: "jasontanner328@gmail.com"
       
        click_button "Get Ya Jobs"      
        
        should have_selector("div", text: "Email Sent!") 
      
      end
    
    end
  
    context "user didnt fill out"
  
      it "email field and not sent" do
       
        fill_in "to", with: ""
       
        expect do   
          click_button "Get Ya Jobs"      
          should have_selector("div", text: "Please fill in your email!") 
        end.to change(ActionMailer::Base.deliveries,:size).by(0)
      
      end
      
      it "email field and alert is shown" do
       
        fill_in "to", with: ""
  
        click_button "Get Ya Jobs"       
        
        should have_selector("div", text: "Please fill in your email!")
      
      end
    
   end
 
end

