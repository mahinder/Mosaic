class SessionsController < ApplicationController

  def new
  end


  def create
    user_name = params[:name]
    password = params[:password]
    user = User.authenticate? user_name, password
      unless user.nil?
        session[:user_id] = user.id
        redirect_to albums_url
      else
        redirect_to login_url, notice: "Invalid user/password combination"
      end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: "Logged out"
  end

end
