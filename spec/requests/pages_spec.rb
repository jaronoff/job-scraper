require 'spec_helper'

describe "Pages" do

  describe "home page" do
  
    subject { page }
    
    before :each do
      visit home_path
    end
    
    
    context "user filled everything out correctly" do
    
      it "email sent" do
       
        fill_in "to", with: "jasontanner328@gmail.com"
       
        expect do   
          click_button "Email Me Daily Posts"      
        end.to change(ActionMailer::Base.deliveries,:size).by(1)
      
      end
    
      it "alert is shown" do
       
        fill_in "to", with: "jasontanner328@gmail.com"
       
        click_button "Email Me Daily Posts"      
        
        should have_selector("div", text: "Email Sent!") 
      
      end
    
    end
  
    context "user didnt fill out"
  
      it "email field and not sent" do
       
        fill_in "to", with: ""
       
        expect do   
          click_button "Email Me Daily Posts"      
          should have_selector("div", text: "Please fill in your email!") 
        end.to change(ActionMailer::Base.deliveries,:size).by(0)
      
      end
      
      it "email field and alert is shown" do
       
        fill_in "to", with: ""
  
        click_button "Email Me Daily Posts"       
        
        should have_selector("div", text: "Please fill in your email!")
      
      end
    
   end
 
end

