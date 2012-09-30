require 'spec_helper'

describe StudentController do
  
    before(:each) do
       @current_user = User.create(:username => 'admin',:password => 'admin123',:first_name => 'Fedena', :last_name => 'Administrator',:email=> 'admin@fedena.com',:role=> 'Admin')
      session[:user_id] = @current_user.id
    end 
    
  describe "GET 'Admission no'" do

     it "should be successful for index" do
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200, :admission_date => Date.today, :batch_id => "1",:gender => "m",:user_id=>1,:student_category_id => 1)
        get :admission_no ,:id => student1.admission_no , :format => :json
        response.should be_success
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Admission no has already been taken/  
     end
  end
  
  describe "GET 'Email Validate'" do

     it "should be successful for email_validation" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1,:email=> 'admin@fedena.com')
        get :email_validation ,:id => student1.email , :format => :json
        response.should be_success
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should =~ /Email has already been taken/  
     end
  end  
  
  describe "GET student_wizard_first & second step & previous step" do

     it "should be successful for student_wizard_first_step" do
        get :student_wizard_first_step 
        response.should be_success
     end
 
     it "should create student in student_wizard_next_step" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "S1",:date_of_birth => Date.today-1200, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1,:class_roll_no =>2)
       session[:student_params] = {}
       session[:student_step] = "image";
       student = {:first_name => 'Abhinav',:last_name => 'Bindra',:admission_date => Date.today, :admission_no => "S2", :date_of_birth => Date.today-5.year,:gender => 'm', :batch_id => batch.id}
        expect {
          get :student_wizard_next_step, :student => student
        }.to change(Student, :count).by(1)
     end
    
     # it "should be successful for student_wizard_previous_step" do
       # batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       # course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       # course.batches =[batch]
       # course.save      
       # student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1)
       # session[:student_step] = "address";
       # session[:student_params] = {:first_name => 'Abhinav',:last_name => 'Bindra',:admission_date => Date.today, :admission_no => 3, :date_of_birth => Date.today-5.year,:gender => 'm', :batch_id => batch.id, :class_roll_no =>""}
       # get :student_wizard_previous_step
       # session[:student_step].should eq("personal")
       # response.should render_template("student_wizard_first_step")
     # end                     
  end  

  describe "GET assign_roll_no" do

     it "should render assign_roll_no_to_batch for assign_roll_no" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        get :assign_roll_no ,:id => batch.id 
        response.should render_template("student/_assign_roll_no_to_batch")
     end
     
     it "should render batch_student for assign_roll_no" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       course.batches =[batch]
       course.save 
        get :assign_roll_no ,:q => course.id 
        response.should render_template("student/_batch_student")
     end        
  end    

  describe "GET change_student_image" do

     it "should render student_image" do
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200, :admission_date => Date.today, :batch_id => "1",:gender => "m",:user_id=>1,:student_category_id => 1) 
        get :change_student_image ,:id => student1.id 
        response.should render_template("student/_student_image")
     end
  end 
  
  describe "GET change_roll_number" do

     it "should change the roll No of student" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        student2= Student.create(:first_name =>"Amar",:last_name => "Kumar",:admission_no => "3",:date_of_birth => Date.today-700,:class_roll_no => 25, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>2,:student_category_id => 1)
        student3= Student.create(:first_name =>"Pooja",:last_name => "Punchouty",:admission_no => "4",:date_of_birth => Date.today-1000,:class_roll_no => 24, :admission_date => Date.today, :batch_id => batch.id,:gender => "f",:user_id=>3,:student_category_id => 1)
        get :change_roll_number ,:query => "assign_Name",:batch_id =>batch.id
        stud = Student.find_by_admission_no(2)
        stud.class_roll_no.should eq("3")
        response.should render_template("student/_assign_roll_no_to_batch")
     end
  end 
  
  describe "PUT update" do

     it "should update the name of student" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        put :update ,:student => {:first_name =>"Keshav"}
        stud = Student.find_by_admission_no(2)
        stud.first_name.should eq("Keshav")
        response.should redirect_to("/student/student_wizard_next_step")
     end
     
     it "should save the Guardian" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
       lambda do
        put :update ,:commit => "Save",:first_name => "Father",:last_name => "Singh",:relation => "Father",:dob => Date.today-25.year, :education => "10th",:occupation => "Farmer",:income =>800,
        :office_phone1 => 2520002,:office_phone2 => 2555255,:mobile_phone => 9874563210,:office_address_line1 => "",:office_address_line2 => "",:city =>"",:state => "",:email => "", :guardian =>{:country_id => 76},:format => :json
        end.should change(Guardian , :count).by(1)
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should == "Guardian is successfully Created."
     end     
  end 
  
  describe "GET my_profile" do

     it "should suceess for my_profile" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        get :my_profile ,:q => student1.admission_no
        response.should be_success
        response.should render_template("student/my_profile")
     end 
  end
  
  describe "GET update_student_image" do

     it "should update student image" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        get :update_student_image ,:id => student1.id, :student => {:student_photo_file_name => '/assets/blue-corner.png'}
        response.should redirect_to("/student/image_crop?id=#{student1.id}")
     end 
  end
  
  describe "GET update_immediate" do

     it "should update student Immediate contact Id" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        guardian = Guardian.create(:first_name => "Father",:last_name => "Singh",:relation => "Father",:dob => Date.today-25.year, :education => "10th",:occupation => "Farmer",:income =>800,
        :office_phone1 => 2520002,:office_phone2 => 2555255,:mobile_phone => 9874563210,:office_address_line1 => "",:office_address_line2 => "",:city =>"",:state => "",:email => "", :country_id => 76)
        get :update_immediate ,:student_id => student1.id ,:id => guardian.id ,:format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['guardian_number'].should == "9874563210"
     end 
  end 
  
  describe "GET update_crop_image" do

     it "should not update crop image" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        get :update_crop_image ,:student_id => student1.id, :student => {:student_photo => ""}
         response.should redirect_to("/student.#{student1.id}")
     end 
  end 

  describe "GET image_crop" do

     it "should not update crop image" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        get :image_crop ,:id => student1.id 
        response.should render_template("student/_student_image_crop")
     end 
  end
  
  describe "GET student_search" do

    it "should be succesfull for student_search" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       course.batches =[batch]
       course.save 
       get :student_search ,:q => course.id 
       response.should render_template("student/student_search")
     end 
  end
  
  describe "GET update_student" do

     it "should update the student" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        get :update_student ,:id => student1.id ,:student => {:first_name => 'makhan', :last_name => 'lal', :middle_name => 'johar'}, :format => :json
        parsed_body = JSON.parse(response.body)
        parsed_body['notice'].should == "Student is successfully updated!"
        stud = Student.find_by_admission_no(2)
        stud.first_name.should eq("Makhan")
     end 
  end    
  
  describe "GET change_batch" do

     it "should render partial batcht" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       course.batches =[batch]
       course.save 
        get :change_batch ,:q => course.id 
        response.should render_template("student/_batch")
     end 
  end 
  
  describe "GET student_advanced_search" do

     it "should search the student with query" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       course.batches =[batch]
       course.save 
       student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1)
        get :student_advanced_search ,:query => batch.id 
        response.should render_template("student/student_advanced_search")
     end 
     
     it "should search the student with out query" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       course.batches =[batch]
       course.save 
       student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1)
        get :student_advanced_search ,:w => ["hul",course.id]
        response.should render_template("student/student_advanced_search")
     end 
  end
  
  describe "GET update_guardian" do

     it "should update the guardian" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       course.batches =[batch]
       course.save 
       student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1)
       guardian = Guardian.create(:ward_id => student1.id,:first_name => "Manoj", :last_name => "Kumar", :relation => "Father") 
       get :update_guardian ,:guardian => {:ward_id => student1, :first_name => "Vikas"},:parent_id => guardian.id , :format => :json
       parsed_body = JSON.parse(response.body)
       parsed_body['notice'].should == "Guardian is successfully Updated."
     end 
  end    
  describe "GET admission4" do

     it "should save the student additional detail" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       course.batches =[batch]
       course.save 
       additional_field1 = StudentAdditionalField.create(:name => "Passport Number",:status => true)
       additional_field2 = StudentAdditionalField.create(:name => "Licence Number",:status => true)
       student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1)
       get :admission4 , :id => student1.id ,:student_additional_details => {additional_field1.id=>{"additional_info"=>"123456"}, additional_field2.id=>{"additional_info"=>"2525"}}
       response.should be_success
       flash.now[:notice].should  == "Student records saved for #{student1.first_name} #{student1.last_name}."
     end 
     
    it "should update the student additional detail" do
       batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
       course = Course.new(:course_name => "Pre Nursery" ,:code => "Prep",:level => 1)
       course.batches =[batch]
       course.save 
       additional_field1 = StudentAdditionalField.create(:name => "Passport Number",:status => true)
       additional_field2 = StudentAdditionalField.create(:name => "Licence Number",:status => true)
       student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1)
       additional_detail1 = StudentAdditionalDetails.create(:student_id => student1.id, :additional_field_id => additional_field1.id,:additional_info => "None")
       additional_detail2 = StudentAdditionalDetails.create(:student_id => student1.id, :additional_field_id => additional_field2.id,:additional_info => "None Same")
       get :admission4 , :id => student1.id ,:student_additional_details => {additional_field1.id=>{"additional_info"=>"None"}, additional_field2.id=>{"additional_info"=>"None Same"}}
       response.should be_success
       flash.now[:notice].should  == "Student records updated for #{student1.first_name} #{student1.last_name}."
     end   
  end 
  
    describe "GET add_guardian" do

     it "should add the guardian for student" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        guardian = {:first_name => "Father",:last_name => "Singh",:relation => "Father",:dob => Date.today-25.year, :education => "10th",:occupation => "Farmer",:income =>800,:ward_id => student1.id,
        :office_phone1 => 2520002,:office_phone2 => 2555255,:mobile_phone => 9874563210,:office_address_line1 => "",:office_address_line2 => "",:city =>"",:state => "",:email => "", :country_id => 76}
        get :add_guardian ,:guardian => guardian ,:format => :json
        parsed_body = JSON.parse(response.body)
        response.should be_success
        flash.now[:notice].should  == "Guardian is successfully Created."
     end 
  end 
  
  describe "GET search_ajax" do

     it "should search the present student" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        get :search_ajax ,:query => "rah,active"
        response.should render_template("student/_student_search")
     end 
     
    it "should search the former student" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= ArchivedStudent.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:student_category_id => 1) 
        get :search_ajax ,:query => "rah,former"
        response.should render_template("student/_search_ajax")
     end  
  end       
 
  describe "GET profile_pdf" do

     it "should render the pdf of student" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        get :profile_pdf ,:id => student1.id
        response.should render_template("student/profile_pdf")
     end 
  end
  
  describe "GET del_guardian" do

     it "should not delete the guardian" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        guardian = Guardian.create(:ward_id => student1.id,:first_name => "Manoj", :last_name => "Kumar", :relation => "Father") 
        student1.immediate_contact_id = guardian.id
        student1.save
         expect {
          get :del_guardian, :id => guardian.id
         }.to change(Guardian, :count).by(0)
         flash.now[:notice].should  == "Guardian Can not be Deleted"
     end 
     
     it "should delete the guardian" do
        batch = Batch.create(:name => 'A-2011', :start_date => Date.today.beginning_of_year , :end_date => Date.today.end_of_year)
        student1= Student.create(:first_name =>"Rahul",:last_name => "Bajaj",:admission_no => "2",:date_of_birth => Date.today-1200,:class_roll_no => 21, :admission_date => Date.today, :batch_id => batch.id,:gender => "m",:user_id=>1,:student_category_id => 1) 
        guardian = Guardian.create(:ward_id => student1.id,:first_name => "Manoj", :last_name => "Kumar", :relation => "Father") 
         expect {
          get :del_guardian, :id => guardian.id
         }.to change(Guardian, :count).by(-1)
         flash.now[:notice].should  == "Guardian has been deleted"
     end      
     
  end     
                                               
end