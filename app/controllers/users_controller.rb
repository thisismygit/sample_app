class UsersController < ApplicationController
  before_filter :redirect_if_signed_in, :only => [:new, :create]
  before_filter :authenticate, :except => [:show, :new, :create]   # runs authenticate() before edit() and update(), etc...
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => :destroy
  
  def index       # automatically renders the app/views/users/index.html.erb page at the end.  Rails 3 convention
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end
  
  def show
    @user = User.find(params[:id])  #  Think  www.example.com/users/:id
    @microposts = @user.microposts.paginate(:page => params[:page])
    @title = @user.name
  end

  
  def new 
    @user = User.new
    @user.name = "noi"
    @user.email = "f@g.com"
    @title = "Sign up"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign up"
      #@user.password = ""
      render 'new'
    end
  end
  
  def edit  # shows the edit page
    @title = "Edit user"
  end
  
  
  def update   # does the actual work when updating (what ever they filled out in the edit page)
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    if current_user?(User.find(params[:id]))      # if the current_user is the user being destroyed...
      flash[:error] = "Admins can't delete themselves."
      redirect_to users_path
      return false
    end
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  
  private


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def redirect_if_signed_in
      if current_user != nil  # if they're already logged in...
        redirect_to(root_path)
      end
    end
    
end
