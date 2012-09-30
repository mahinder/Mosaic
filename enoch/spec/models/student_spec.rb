# == Schema Information
#
# Table name: students
#
#  id                   :integer         not null, primary key
#  admission_no         :string(255)
#  class_roll_no        :string(255)
#  admission_date       :date
#  first_name           :string(255)
#  middle_name          :string(255)
#  last_name            :string(255)
#  batch_id             :integer
#  date_of_birth        :date
#  gender               :string(255)
#  blood_group          :string(255)
#  birth_place          :string(255)
#  nationality_id       :integer
#  language             :string(255)
#  religion             :string(255)
#  student_category_id  :integer
#  address_line1        :string(255)
#  address_line2        :string(255)
#  city                 :string(255)
#  state                :string(255)
#  pin_code             :string(255)
#  country_id           :integer
#  phone1               :string(255)
#  phone2               :string(255)
#  email                :string(255)
#  immediate_contact_id :integer
#  is_sms_enabled       :boolean         default(TRUE)
#  photo_file_name      :string(255)
#  photo_content_type   :string(255)
#  photo_data           :binary(76800)
#  status_description   :string(255)
#  is_active            :boolean         default(TRUE)
#  is_deleted           :boolean         default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#  has_paid_fees        :boolean         default(FALSE)
#  photo_file_size      :integer
#  user_id              :integer
#

require 'spec_helper'

#Author : Puja
#Date : Nov 29th, 30th 2011

describe ElectiveGroup do

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
    @student = Student.new (@student_attr) 
  end
  
  after(:each) do
    
  end
  
  it "should have a batch, student_category, nationality, user attribute, etc.." do
    @student.should respond_to(:country)
    @student.should respond_to(:batch)
    @student.should respond_to(:student_category)
    @student.should respond_to(:nationality)
    @student.should respond_to(:user)
    @student.should respond_to(:graduated_batches)
    @student.should respond_to(:student_previous_data)
    @student.should respond_to(:immediate_contact)
    @student.should respond_to(:student_previous_subject_mark)
    @student.should respond_to(:guardians)
    @student.should respond_to(:finance_transactions)
    @student.should respond_to(:attendances)
    @student.should respond_to(:finance_fees)
    @student.should respond_to(:fee_category)
    @student.should respond_to(:graduated_batches)
  end
  
  it "should have first name for Student" do
    no_first_name_student = Student.new (@student_attr.merge(:first_name => ""))
    no_first_name_student.should_not be_valid
  end
  
  it "should have Last name for Student" do
    no_first_name_student = Student.new (@student_attr.merge(:last_name => ""))
    no_first_name_student.should_not be_valid
  end
  
  it "should have gender for Student" do
    no_gender_student = Student.new (@student_attr.merge(:gender => ""))
    no_gender_student.should_not be_valid
  end
  
  it "should have admission no for Student" do
    no_admission_no_student = Student.new (@student_attr.merge(:admission_no => ""))
    no_admission_no_student.should_not be_valid
  end
  
  it "should have date of birth for Student" do
    no_date_of_birth_student = Student.new (@student_attr.merge(:date_of_birth => ""))
    no_date_of_birth_student.should_not be_valid
  end
  
  it "should have date of admission for Student" do
    no_admission_date_student = Student.new (@student_attr.merge(:admission_date => ""))
    no_admission_date_student.should_not be_valid
  end
  
   it "should have batch for Student" do
    no_batch_for_student = Student.new (@student_attr.merge(:batch => nil))
    no_batch_for_student.should_not be_valid
  end
    
  it "should not have special characters in admission number" do
    invalid_admission_no_student = Student.new (@student_attr.merge(:admission_no => "$%^"))
    invalid_admission_no_student.should_not be_valid
  end
  
  it "should be a valid email id" do
    invalid_email_student = Student.new (@student_attr.merge(:email => "puja"))
    invalid_email_student.should_not be_valid
  end
  
  it "should have unique admission number - negative" do
    @student = Student.create! (@student_attr)
    @student1 = Student.new (@student_attr)
    @student1.should_not be_valid 
  end
  
  it "should have unique admission number - positive" do
    @student = Student.create!(@student_attr.merge(:admission_no => "1235", :email => "pujaa@ezzie.in"))
    @student1 = Student.new (@student_attr.merge(:admission_no => "1236", :email => "pujaaaa@ezzie.in"))
    @student1.should be_valid 
  end

  it "should create associated user along with the student and update user id in Student record" do
    @student = Student.create!(@student_attr.merge(:admission_no => "puja123", :email => "puja123@ezzie.in"))
    user_for_student = User.find_by_username("puja123")
    user_for_student.should_not be_blank
    userid_for_student = Student.find_by_user_id(user_for_student)
    userid_for_student.should_not be_blank
  end
  
  it "should return all the active students" do
    student1 = Student.create!(@student_attr.merge(:admission_no => "rajan123", :email => "rajan123@ezzie.in"))
    student2 = Student.create!(@student_attr.merge(:admission_no => "rajan1234", :email => "rajan1234@ezzie.in", :is_active => false))
    students = Student.active
    students.size.should eql(1)
  end
  
   it "future date of birth not allowed - negative" do
    expect {Student.create!(@student_attr.merge(:admission_no => "rajan123", :email => "rajan123@ezzie.in", :date_of_birth => Date.today + 3))}.to raise_exception(ActiveRecord::RecordInvalid)
   end
  
   it "valid date of birth allowed - positive 1" do
    expect {Student.create!(@student_attr.merge(:admission_no => "rajan123", :email => "rajan123@ezzie.in", :date_of_birth => Date.today - 3))}.not_to raise_exception(ActiveRecord::RecordInvalid)
   end
   
   it "Gender to have only two values M / F - negative1" do
    expect {Student.create!(@student_attr.merge(:admission_no => "rajan123", :email => "rajan123@ezzie.in", :gender => "Male"))}.to raise_exception(ActiveRecord::RecordInvalid)
   end
   
   it "Gender to have only two values M / F - negative2" do
    expect {Student.create!(@student_attr.merge(:admission_no => "rajan123", :email => "rajan123@ezzie.in", :gender => "Female"))}.to raise_exception(ActiveRecord::RecordInvalid)
   end
   
    it "Gender to have only two values M / F - positive" do
    expect {Student.create!(@student_attr.merge(:admission_no => "rajan123", :email => "rajan123@ezzie.in", :gender => "M"))}.not_to raise_exception(ActiveRecord::RecordInvalid)
   end
   
    it "Admission number cannot be zero - negative" do
      expect {Student.create!(@student_attr.merge(:admission_no => "0", :email => "rajan123@ezzie.in"))}.to raise_exception(ActiveRecord::RecordInvalid)
    end
    
    it "Admission number cannot be zero - positive" do
      expect {Student.create!(@student_attr.merge(:admission_no => "01", :email => "rajan123@ezzie.in"))}.not_to raise_exception(ActiveRecord::RecordInvalid)
    end
   
   it "return full name for the student" do
      student = Student.new (@student_attr.merge(:first_name => "Puja", :middle_name => "Narang" , :last_name => "Punchouty"))
      student_full_name = student.full_name
      student_full_name.should eql("Puja Narang Punchouty")
    end
    
    it "return gender_as text for Female" do
      student = Student.new (@student_attr.merge(:gender => "F"))
      student_gender = student.gender_as_text
      student_gender.should eql("Female")
    end
    
    it "return gender_as text for Male" do
      student = Student.new (@student_attr.merge(:gender => "M"))
      student_gender = student.gender_as_text
      student_gender.should eql("Male")
    end
    
    it "return first_and_last_name for the student" do
      student = Student.new (@student_attr.merge(:first_name => "Puja", :middle_name => "Narang" , :last_name => "Punchouty"))
      student_full_name = student.first_and_last_name
      student_full_name.should eql("Puja Punchouty")
    end
   
    
   it "return next_student" do
     course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => 4
    }
     course = Course.new course_attr
     batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
     course.batches = [batch]
     course.presence_of_initial_batch
     course.errors.messages.size.should eql(0)
     course.save!
     
     student1 = Student.create!(@student_attr.merge(:admission_no => "001", :batch => batch, :email => "001@ezzie.in"))
     student2 = Student.create!(@student_attr.merge(:admission_no => "002", :batch => batch, :email => "002@ezzie.in"))
     student3 = Student.create!(@student_attr.merge(:admission_no => "003", :batch => batch, :email => "003@ezzie.in"))
     
     student1.next_student.should eql(student2)
     student2.next_student.should eql(student3)
     
     student3.next_student.should_not be_nil
   end
   
   it "return previous_student" do
     course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => 1
    }
     course = Course.new course_attr
     batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
     course.batches = [batch]
     course.presence_of_initial_batch
     course.errors.messages.size.should eql(0)
     course.save!
     
     student1 = Student.create!(@student_attr.merge(:admission_no => "001", :batch => batch, :email => "001@ezzie.in"))
     student2 = Student.create!(@student_attr.merge(:admission_no => "002", :batch => batch, :email => "002@ezzie.in"))
     student3 = Student.create!(@student_attr.merge(:admission_no => "003", :batch => batch, :email => "003@ezzie.in"))
     
     student1.previous_student.should_not be_nil
     student2.previous_student.should eql(student1)
     student3.previous_student.should eql(student2)
     
   end
   
   it "archive_student" do
     course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => 2
    }
     course = Course.new course_attr
     batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
     course.batches = [batch]
     course.presence_of_initial_batch
     course.errors.messages.size.should eql(0)
     course.save!
     
     student1 = Student.create!(@student_attr.merge(:admission_no => "001", :batch => batch, :email => "001@ezzie.in"))
     student1.archive_student("Leaving School")
     student1 = Student.find_by_admission_no("001")
     student1.should be_nil
     archivedStudent = ArchivedStudent.find_by_admission_no("001")
     archivedStudent.should_not be_nil
     archivedStudent.admission_no.should eql("001")
   end
   
   it "should have no or one previous student data and previous subject marks" do
     course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => 2
    }
     course = Course.new course_attr
     batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
     course.batches = [batch]
     course.presence_of_initial_batch
     course.errors.messages.size.should eql(0)
     course.save!
     
     student1 = Student.create!(@student_attr.merge(:admission_no => "001", :batch => batch, :email => "001@ezzie.in"))
     student_previous_data = StudentPreviousData.create!(:institution => "Amity International School", :student => student1)
     student_previous_data.should be_valid
     student1.student_previous_data.should eql(student_previous_data)
     student_previous_data1 = StudentPreviousData.create!(:institution => "Amiown School", :student => student1)
     #If only one record per student for StudentPreviousData is allowed then only one record should be created the below should not be valid,
     #but database allows to create multiple StudentPreviousData
     student_previous_data1.should be_valid
     #Also the below statement shows that it doesnt recover the next record of StudentPreviousData
     student1.student_previous_data.should_not eql(student_previous_data1)
     
     student_previous_subject_mark1 = StudentPreviousSubjectMark.create!(:student => student1, :subject => "Maths", :mark => 80)
     student_previous_subject_mark2 = StudentPreviousSubjectMark.create!(:student => student1, :subject => "Science", :mark => 78)
     
     student1.student_previous_subject_mark.should include(student_previous_subject_mark1)
     student1.student_previous_subject_mark.should include(student_previous_subject_mark2)
     
   end
   
   it "should have multiple finance fees" do
     course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => 2
    }
     course = Course.new course_attr
     batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
     course.batches = [batch]
     course.presence_of_initial_batch
     course.errors.messages.size.should eql(0)
     course.save!
     student = Student.create!(@student_attr.merge(:admission_no => "001", :batch => batch, :email => "001@ezzie.in"))
     finance_fee_category = FinanceFeeCategory.create!(:name => "Monthly", :batch => batch) 
     finance_fee_collection1 = FinanceFeeCollection.create!(:name => "Monthly",
      :start_date => 1.year.ago,
      :fee_category => finance_fee_category,
      :end_date => 1.year.ago,
      :due_date => 1.month.ago)

     finance_fee_collection2 = FinanceFeeCollection.create!(:name => "Monthly",
      :start_date => 2.year.ago,
      :fee_category => finance_fee_category,
      :end_date => 2.year.ago,
      :due_date => 2.month.ago)
      
     finance_fee1 = FinanceFee.create!(:student => student ,:fee_collection_id => finance_fee_collection1)
     finance_fee2 = FinanceFee.create!(:student => student ,:fee_collection_id => finance_fee_collection1)
     
     student.finance_fees.should include(finance_fee1)
     student.finance_fees.should include(finance_fee2)
     
   end
   
   it "has no or one immediate contact" do
     student = Student.create!(@student_attr)
     guardian_for_student = Guardian.create!(:first_name => "Papa", :relation => "Father", :ward => student)
     student.immediate_contact_id = guardian_for_student.id
     student.save!
     student.immediate_contact.should eql(guardian_for_student)
   end
   
   it "has many guardians" do
     student = Student.create!(@student_attr)
     guardian_for_student1 = Guardian.create!(:first_name => "Papa", :relation => "Father", :ward => student)
     guardian_for_student2 = Guardian.create!(:first_name => "Mumma", :relation => "Mother", :ward => student)
     student.immediate_contact_id = guardian_for_student1.id
     student.save!
     student.guardians.should include(guardian_for_student1)
     student.guardians.should include(guardian_for_student2)
   end
   
   it "should return graduated batches" do
     course_attr = {
      :course_name => "Grade 8",
      :code => "8th",
      :level => 9
    }
     course = Course.new course_attr
     batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago
     course.batches = [batch]
     course.presence_of_initial_batch
     course.errors.messages.size.should eql(0)
     course.save!
     student = Student.create!(@student_attr.merge(:admission_no => "001", :batch => batch, :email => "001@ezzie.in"))
     batch.graduated_students = [student]
     newbatch = Batch.new :name => 'Science', :start_date => 1.year.ago , :end_date => 1.month.ago
     student.batch = newbatch
     student.all_batches.should include(batch)
     student.all_batches.to_a.should include(newbatch)
     
     student.graduated_batches.should include(batch)
   end
   
end
