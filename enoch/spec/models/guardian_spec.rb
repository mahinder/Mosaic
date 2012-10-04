# == Schema Information
#
# Table name: guardians
#
#  id                   :integer         not null, primary key
#  ward_id              :integer
#  first_name           :string(255)
#  last_name            :string(255)
#  relation             :string(255)
#  email                :string(255)
#  office_phone1        :string(255)
#  office_phone2        :string(255)
#  mobile_phone         :string(255)
#  office_address_line1 :string(255)
#  office_address_line2 :string(255)
#  city                 :string(255)
#  state                :string(255)
#  country_id           :integer
#  dob                  :date
#  occupation           :string(255)
#  income               :string(255)
#  education            :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

require 'spec_helper'

describe Guardian do
before(:each) do
  @guardian_attr = {
  :first_name => "sunil papa",
  :relation => "father"
  }
end
  
  
  describe "validation" do
  it "guardian should exist in database" do
  guardian = Guardian.new(@guardian_attr)
  guardian.should be_valid
  end
  it "should pass for name presence" do
    guardian = Guardian.new(@guardian_attr.merge(:first_name => ""))
  guardian.should_not be_valid
  end
  it "should pass for relation presence" do
    guardian = Guardian.new(@guardian_attr.merge(:relation => ""))
  guardian.should_not be_valid
  end
  it "should pass for country association" do
    guardian = Guardian.new(@guardian_attr)
  guardian.should respond_to(:country)
  end
  it "should pass for ward association" do
    guardian = Guardian.new(@guardian_attr)
  guardian.should respond_to(:ward)
  end
  end
  describe "validation method" do
    it "should exist validation method " do
    guardian = Guardian.new(@guardian_attr)
  guardian.should respond_to(:validate)
  end
    it "should raise error" do
       guardian = Guardian.new(@guardian_attr.merge(:dob => Date.today+1))
       guardian.validate
       guardian.errors.messages[:dob].should include("cannot be a future date.")
    end
  end
  
  it "should return full name " do
     guardian = Guardian.create!(@guardian_attr.merge(:last_name => "kumar"))
     guardian.full_name.should eql ("sunil papa kumar")
     
  end
  
  describe "archive guardian" do
    it "should return archived guardian" do
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
    student = Student.create!(@student_attr)
    archived_student = student.archive_student("Leaving School")
    guardian = Guardian.create!(@guardian_attr.merge(:ward => student))
    returned_guardian = guardian.archive_guardian(archived_student)
    
    archive_guardian = ArchivedGuardian.find_by_first_name("sunil papa")
    end
    it "immediate_contect_id" do
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
    student = Student.create!(@student_attr)
     guardian = Guardian.new(@guardian_attr.merge(:ward => student))
     guardian.is_immediate_contact?.should be_true
    end
  end
end
