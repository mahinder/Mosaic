require 'spec_helper'



describe BatchesController  do
  before(:each) do
    Employee.delete_all
    EmployeeCategory.delete_all
    User.delete_all
    empcat = {
      :name  =>'Category1',
      :prefix  =>  'E1',
      :status =>  true
    }
   
    @employee_category = EmployeeCategory.create(empcat)
    puts @employee_category
    @current_user = User.create(:username => 'admin',:password => 'admin123',:first_name => 'enoch',:last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
    emp = {
      :employee_category_id => @employee_category.id,
      :employee_number => 'admin',
      :first_name => 'enoch',
      :user_id => @current_user.id
    }
    @employee = Employee.create(emp)
    puts @employee
    session[:user_id] = @current_user.id
    puts @employee.user
    puts @current_user.employee_record
    @attr = {
      :course_name => "Grade 10",
      :code => "10",
      :section_name => "A",
      :level        => 1
    }
    @course = Course.new @attr
    batch_attr1 = {
      :name => "c",
      :start_date => 1.year.ago,
      :end_date => 1.month.ago
    }
    @classtiming_attr = {
      :name => "classtiming",
      :start_time => "02:00 AM",
      :end_time => "03:00 AM",

    }
    @class_timing = ClassTiming.create!(@classtiming_attr)
    @batch = Batch.new(batch_attr1)
    @course.batches = [@batch]
    @course.save!

  end
  render_views
  describe "GET 'all_record'" do

    it "should be successful" do
     puts @user
      get :all_record,:course_id => @course.id,:id => @batch.id
      response.should be_success
    end

    it "should have grades in html table" do
      get :all_record,:course_id => @course.id,:id => @batch.id
      response.should have_selector('a', :content => "Students")
      response.should have_selector('a', :content => "Subjects")
      response.should have_selector('a', :content => "Time Slots")
      response.should have_selector('td', :content => "02:00 AM")
      response.should have_selector('td', :content => "03:00 AM")

    end
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index,:course_id => @course.id,:id => @batch.id
      response.should be_success
    end
  end

  describe "GET 'update_batch_subject'" do
    it "should be successful" do
      get :index,:course_id => @course.id,:id => @batch.id
      response.should be_success
    end
  end
  describe "Update" do
    it "should update the batch" do
      attr = {:name => "d", :start_date => 1.year.ago, :end_date => 1.month.ago }
      put :update, :id => @batch.id,:batch => attr,:course_id => @course.id, :format => :json
      parsed_body = JSON.parse(response.body)
      if parsed_body["valid"] == true
        get :update_batch_subject,:course_id => @course.id,:id => @batch.id
        response.should render_template('batches/_batch')
      else
        response.should render_template("")
      end
    end
  end

  describe "GET 'select_batch'" do
    it "should render template" do
      get :select_batch,:course_id => @course.id,:id => @batch.id
      response.should render_template("batches/_select_batch")
    end
  end
  describe "GET 'subject_students'" do
    before(:each) do
    @student_attr = {
      :first_name => "Puja",
      :last_name => "Punchouty",
      :admission_date => Date.today,
      :admission_no => "1234",
      :batch_id => "1", 
      :date_of_birth => Date.today - 2190,
      :gender => "F",
      :email => "puja@ezzie.in"
    } 
    @student = Student.create!(@student_attr) 
    @subject_attr = {
      :name => "General Health",
      :code => "General Health",
      :no_exams => true ,
      :max_weekly_classes => 2,
      :batch_id => @batch.id
   }
   
  end
    # if elective_group is  nil
    #@studentsubject = Student.cre
    it "should render template" do
      get :subject_students,:course_id => @course.id,:elective_group => 1,:batch => @batch.id,:format => :JSON
      response.should render_template("batches/_subject_students")
    end
  
  
  
  end
  describe "GET 'teacher'" do
    it "should render template after employee search" do
      get :teacher,:course_id => @course.id,:batch_id => @batch.id,:format => :JSON,:value => 'k'
      response.should render_template("batches/_employee")
      
    end
  end
  describe "JSON POST 'create'" do
    
     describe "failure" do
       
        it "should be resopnd with error for empty name" do
          batch_attr = {:name => "",:start_date => 1.year.ago,:end_date => 1.month.ago,:course_id => @course.id}
          post :create,:course_id => @course.id,:batch => batch_attr, :format => :json
          parsed_body = JSON.parse(response.body)
          parsed_body['errors']['name'][0].should =~ /can't be blank/
        end
     end
     describe "success" do
       
       it "should successfully add record" do
        batch_attr = {:name => "abc",:start_date => 1.year.ago,:end_date => 1.month.ago,:course_id => @course.id}
        lambda do
          post :create,:course_id => @course.id,:batch => batch_attr, :format => :json
        end.should change(Batch, :count).by(1)
      end
      it "should successfully create subject" do
         @skill_attr = {:name => "language",:code => "language",:max_weekly_classes => 5,:course_id => @course.id}
          @skill=Skill.create!(@skill_attr)
         batch_attr = {:name => "abc",:start_date => 1.year.ago,:end_date => 1.month.ago,:course_id => @course.id}
        lambda do
          post :create,:course_id => @course.id,:batch => batch_attr, :format => :json
        end.should change(Subject, :count).by(1)
      end
       
     end
  end
  describe "GET 'assign_student_to_sub'" do
    it "should render template for assign students" do
      get :assign_student_to_sub,:course_id => @course.id,:batch_id => @batch.id,:format => :JSON
      response.should render_template("batches/_assign_sub_student1")
      
    end
  end
  
  
  
end
