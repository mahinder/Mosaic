class AdminController < ApplicationController
  before_filter :authorize 
  def index
    @current_user = current_user
  end

end
