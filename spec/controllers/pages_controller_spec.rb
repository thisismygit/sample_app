require 'spec_helper'

describe PagesController do
  render_views

  before(:each) do
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  describe "GET 'home'" do
    
    describe "when not signed in" do

      before(:each) do
        get :home
      end
    
      it "should be successful" do
        response.should be_success
      end
    
      it "should have the right title" do
        response.should have_selector("title",
                                      :content => "#{@base_title} | Home")
      end
    end
    
    describe "when signed in" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email))
        other_user.follow!(@user)
      end
      
      it "should have the right follower/following counts" do
        get :home
        response.should have_selector("a", :href => following_user_path(@user),
                                           :content => "0 following")
        response.should have_selector("a", :href => followers_user_path(@user),
                                           :content => "1 follower")
      end
    end
    
    
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
               :content => "Ruby on Rails Tutorial Sample App | Home")
    end
    
    #when signed in
    describe "for signed in users" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))      # sign in
      end
      
      it "should display proper micropost pluralization" do
        get 'home'
        response.should have_selector('span.microposts', :content => "0 microposts")
        mp1 = Factory(:micropost, :user => @user, :content => "Foo bar")
        get 'home'
        response.should have_selector('span.microposts', :content => "1 micropost")
        Factory(:micropost, :user => @user, :content => "Foo bar")
        get 'home'
        response.should have_selector('span.microposts', :content => "2 microposts")
      end
    end
    
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end

    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
               :content => "Ruby on Rails Tutorial Sample App | Contact")
    end
  end


  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
               :content => "Ruby on Rails Tutorial Sample App | About")
    end
  end

end
