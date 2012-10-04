# == Schema Information
#
# Table name: archived_guardians
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

describe ArchivedGuardian do
before(:each) do
  @archive_guardian_attr = {
  :first_name => "sunil",
  :relation => "father"
  }
  describe "validation" do
  it "guardian should exist in database" do
  archived_guardian = ArchivedGuardian.new(@archive_guardian_attr)
  archived_guardian.should be_valid
  end
   it "should respond to country" do
     archived_guardian = ArchivedGuardian.new(@archive_guardian_attr)
     archived_guardian.should respond_to(:country)
   end
   it "should respond to ward" do
     archived_guardian = ArchivedGuardian.new(@archive_guardian_attr)
     archived_guardian.should respond_to(:ward)
   end
   end
  
  it "should return full name " do
     archived_guardian = ArchivedGuardian.create!(@archive_guardian_attr.merge(:last_name => "kumar"))
     archived_guardian.full_name.should eql ("sunil kumar")
     
  end

    it "immediate_contect_id" do
     @archive_student_attr = {
      :first_name => "Puja Punchouty",
      :admission_date => Date.today,
      :admission_no => "1234",
      :batch_id => "1", 
      :date_of_birth => Date.today - 2190,
      :gender => "F",
      :email => "puja@ezzie.in"
    } 
    archived_student = ArchivedStudent.create!(@archive_student_attr)
     archived_guardian = Guardian.new(@archived_guardian_attr.merge(:ward => archived_student))
     archived_guardian.is_immediate_contact?.should be_true
    end
  end
end
