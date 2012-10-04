class AttendanceServiceController < ApplicationController
   
   
  def sign_in
    user_name = params[:username]
    password = params[:password]
    user = User.authenticate? user_name, password
    puts "user_name is #{user_name}"
     puts "password is #{password}"
      puts "user is #{user}"
    if user.nil?
      render :json => {:valid => false, :error => "Invalid username or password combination"}
    else
      render :json => {:valid => true, :success => "Successfully Logged in"}
    end
  end 
    
  def markEmployeeAttendane
   
    puts current_user
     render :json => {:valid => true,:notice => "Marked Successfully"}
  end
end
