class SessionsController < ApplicationController

  def new
    @title = "Sign in"
    #@session = Session.new      # since there's no model, we can't setup the form automatically...
    #@session.email 
  end

  def create                                         # we get here by clicking the submit button on the sessions/new.html.erb form
    user = User.authenticate(params[:session][:email],  
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_or user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
