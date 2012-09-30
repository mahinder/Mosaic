#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

class NewsController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  def add
    @news = News.new(params[:news])
    @news.author = current_user
    if request.post? and @news.save
      sms_setting = SmsSetting.new()
      if sms_setting.application_sms_active
        students = Student.find(:all,:select=>'phone2',:conditions=>'is_sms_enabled = true')
      end
      flash[:notice] = 'News added!'
      redirect_to :controller => 'news', :action => 'view', :id => @news.id
    end
  end

  def add_comment
    @cmnt = NewsComment.new(:content => params[:comment], :news_id => params[:newsId])
    @cmnt.author = current_user
    @cmnt.save
    @news = News.find_by_id(params[:newsId])
    @comments = @news.comments
    if !@comments.empty?
   
      @comments = @comments.paginate(:page => params[:page], :per_page => 5) 

    end  
     render  :partial => "comment"

  end

  def all
   @news = News.paginate :page => params[:page]
  end

  def delete
    @news = News.find(params[:id]).destroy
    @comment = NewsComment.find_all_by_news_id(params[:id])
    @comment.each do |c|
      c.destroy
    end
    @news.destroy
    flash[:notice] = 'News item deleted successfully!'
    redirect_to :controller => 'news', :action => 'index'
  end

  def delete_comment
    @comment = NewsComment.find(params[:id])
    NewsComment.destroy(params[:id])
    @news = News.find_by_id(params[:news_id])
    @comments = @news.comments
    if !@comments.empty?
  
      @comments = @comments.paginate(:page => params[:page], :per_page => 5) 
      
    end  
    render :partial => 'comment'
  end

  def edit
    @news = News.find(params[:id])
    if request.post? and @news.update_attributes(params[:news])
      flash[:notice] = 'News updated!'
      redirect_to :controller => 'news', :action => 'view', :id => @news.id
    end
  end

  def index
    @current_user = current_user
    @news = []
    if request.post?
      # @news = News.title_like_all params[:query].split unless params[:query].nil?
    conditions = ["title LIKE ?", "%#{params[:query]}%"]
    @news = News.find(:all, :conditions => conditions) unless params[:query] == ''
    end
  end

  def search_news_ajax
    @news = nil
    conditions = ["title LIKE ?", "%#{params[:query]}%"]
    @news = News.find(:all, :conditions => conditions) unless params[:query] == ''
    render :partial => 'search_news_ajax'
  end

  def view
    @current_user = current_user
    @news = News.find(params[:id])
    @comments = @news.comments
    if !@comments.empty?
      
      @comments = @comments.paginate(:page => params[:page], :per_page => 5) 
    
    end    
  end
end
