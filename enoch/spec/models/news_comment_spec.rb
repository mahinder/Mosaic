# == Schema Information
#
# Table name: news_comments
#
#  id         :integer         not null, primary key
#  content    :text
#  news_id    :integer
#  author_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'
describe NewsComment do

  before(:each) do
    @attr = {
      :title=> "Hello",
      :content => "Good Morning"
    }
     
    @user = {
      :username =>"Shakti",
      :first_name =>"Shakti",
      :last_name=> "Singh",
      :email=> "shakti@yahoo.com",
      :role => "Admin",
      :password =>"password",
      :confirm_password => "password"
    }  
  end 
  
  it "should create a new News Comment" do
    @news = News.create!(@attr)
    @author = User.create!(@user)
    NewsComment.create!(:content=> "Hello", :author => @author,:news_id => @news )
  end
  
   it "should have a association in New Comment" do
      @news = News.create!(@attr)
      @author = User.create!(@user)
      @news_comment=  NewsComment.create!(:content=> "Hello", :author => @author,:news_id => @news )
      @news_comment.should respond_to(:news)
      @news_comment.should respond_to(:author)
      @news_comment.should respond_to(:content)
    end 
  
end
