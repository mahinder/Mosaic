class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter { |controller| Authorization.current_user = controller.current_user }

  def current_user
    User.find_by_id(session[:user_id]) unless session[:user_id].nil?
  end
  
  protected
  def authorize
    unless User.find_by_id(session[:user_id])
    redirect_to login_url, notice: "Please log in"
    end
  end

  def protect_other_user_album
    @album = Album.find_by_id(params[:id])
    unless current_user.albums.include? @album
        flash[:notice] = "You are not allowed to view other user's album"
        redirect_to albums_url
    end
  end
  def protect_other_user
    user = User.find_by_id(params[:id])
        if user.nil? || current_user.id != user.id
            flash[:notice] = "You are not allowed to do this"
            redirect_to albums_url
        end
  end
end
