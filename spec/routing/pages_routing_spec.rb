require 'spec_helper'


describe "Page Routing" do
  

  it "should route to root as pages#home" do
   expect(get: '/').to route_to({ controller: 'pages', action: 'home' })
  end
  it "should route pages#home" do
   expect(get: 'home').to route_to({ controller: 'pages', action: 'home' })
  end
  it "should route pages#about" do
   expect(get: '/about').to route_to({ controller: 'pages', action: 'about' })
  end
  it "should route pages#mail" do
   expect(post: '/mail').to route_to({ controller: 'pages', action: 'mail' })
  end
  it "should route pages#jobs" do
   expect(get: '/jobs').to route_to({ controller: 'pages', action: 'jobs' })
  end
 
 
end

