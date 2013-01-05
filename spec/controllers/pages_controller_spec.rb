require 'spec_helper'

describe PagesController do

    context "for checking home" do
      before do
        get :home
      end
      
      it { should respond_with(:success) }
      it { should render_template(:home) }
  
    end

    context "for checking about" do
      before do
        get :about
      end
      
      it { should respond_with(:success) }
      it { should render_template(:about) }
  
    end      

    context "for checking jobs" do
      before do
        get :jobs
      end
      
      it { should respond_with(:success) }
      it { should render_template(:jobs) }
  
    end   


    context "for checking jobs" do
      before do
        get :jobs
      end
      
      it { should respond_with(:success) }
      it { should render_template(:jobs) }
  
    end   
    
    context "jobs redirects to homepage when nothing returned from crawlers" do
      before do
        PagesController.any_instance.stub(:scrap_cl).and_return("")
        get :jobs
      end
    
      it { should respond_with(:redirect) }
      it { should redirect_to(home_path) } 
      it { should set_the_flash.to("Nothing found this month!")}      
      
    end


    context "for checking mail w/o parameters" do
      before do
        get :mail, to: ""
      end
      
      it { should respond_with(:redirect) }
      it { should redirect_to(home_path) }
      it { should set_the_flash.to("Please fill in your email!")}
 
    end    


    context "for checking mail with parameters" do
      before do
        get :mail, to: "jason@jason.com"
      end
      
      it { should respond_with(:redirect) }
      it { should redirect_to(home_path) } 
      it { should set_the_flash.to("Email Sent!")} 
    end   

    context "for checking mail with parameters" do
      before do
        get :mail, to: "jasonjason.com"
      end
      
      it { should respond_with(:redirect) }
      it { should redirect_to(home_path) } 
      it { should set_the_flash.to("Email Sent!")} 
    end  

end
