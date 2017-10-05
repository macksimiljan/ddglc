class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_code(params[:session][:code])
    if user && user.activated && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
      flash[:success] = "Hello #{user.code}. You are logged in as #{user.role}. Welcome back."
    else
      flash.now[:danger] = 'Unable to login. Check your abbreviation and password.'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
    flash[:warning] = 'You are logged out.'
  end
end
