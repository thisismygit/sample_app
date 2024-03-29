class MicropostsController < ApplicationController
  before_filter :authenticate, :only => [:create, :destroy, :index]
  before_filter :authorized_user, :only => :destroy
  
  def index
    @feed_items = User.find(params[:id]).feed.paginate(:page => params[:page])
  end
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])   # this pulls out micropost[content] from the form submitted
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_back_or root_path
  end
  
  private
  
    def authorized_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil?
    end
end
