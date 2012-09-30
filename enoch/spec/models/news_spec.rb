# == Schema Information
#
# Table name: news
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  content    :text
#  author_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'
describe News do

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
  
  it "should create a new New" do
    News.create!(@attr)
  end
  
  it "should have a association in news " do
    @news= News.create!(@attr)
    @news.should respond_to(:author)
    @news.should respond_to(:title)
    @news.should respond_to(:content)
    @news.should respond_to(:comments)
  end  
  
  it "should have many news comment" do 
    @news = News.create!(@attr)
    @author = User.create!(@user)
    @news_comment1=NewsComment.create!(:content=> "Hellos", :author => @author,:news_id => @news )
    @news_comment2=NewsComment.create!(:content=> "Hellos", :author => @author,:news_id => @news )
    @news.comments.should == [@news_comment1, @news_comment2]
  end
  
end
