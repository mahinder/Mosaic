# == Schema Information
#
# Table name: courses
#
#  id           :integer         not null, primary key
#  course_name  :string(255)
#  code         :string(255)
#  section_name :string(255)
#  is_deleted   :boolean         default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

#Author : Puja
#Date : Nov 21st 2011 
describe Course do
  
  before(:each) do
    @attr = {
      :course_name => "Grade 10",
      :code => "10",
      :section_name => "A",
      :level        => 1
    }
    @course = Course.new @attr  
  end
  
  it "should have a course name attribute" do
      @course.should respond_to(:course_name)
  end
  
 
  it "should have a code attribute" do
      @course.should respond_to(:code)
  end
  
   it "should have presence_of_initial_batch method" do
      @course.should respond_to(:presence_of_initial_batch)
   end
   it "should have level" do
      @course.should respond_to(:level)
   end
   it "should have pass presence_of_initial_batch method if batches length is 0" do
      @course.presence_of_initial_batch
      @course.errors.messages[:base].should eql(["Should have an initial batch"])
      @course.errors.messages.size.should eql(1)
   end
  
  it "should not have passed presence_of_initial_batch method if batches length is 0" do
      @course.presence_of_initial_batch
      @course.errors.messages[:base].should_not eql(["Invalid"])
      @course.errors.messages.size.should eql(1)
   end
   
  it "should create a new instance of Course" do
       @batch = Batch.new :name => 'Maths', :start_date => 1.year.ago , :end_date => 1.month.ago   
       @course.batches = [@batch]  
       @course.presence_of_initial_batch
       @course.errors.messages.size.should eql(0)
       @course.save!     
  end
  
  it "check the batches length if not 0 then errors should be null" do
       @batch = Batch.new :name => 'Science', :start_date => 1.year.ago , :end_date => 1.month.ago   
       @course.batches = [@batch]  
       @course.presence_of_initial_batch
       @course.errors.messages.size.should eql(0)
  end
  
  it "should require a course name" do
    no_name_course = Course.new(@attr.merge(:course_name => ""))
    no_name_course.should_not be_valid
  end
  
  it "should require a course level" do
    no_level = Course.new(@attr.merge(:level => ""))
    no_level.should_not be_valid
  end
  
  it "should require a course code" do
    no_code_course = Course.new(@attr.merge(:code => ""))
    no_code_course.should_not be_valid
  end 
  
  it "should reject course names that are too long" do
    long_name = "a" * 51
    long_name_course = Course.new(@attr.merge(:course_name => long_name))
    long_name_course.should_not be_valid
  end
  
  it "should reject course names that are too long" do
    long_name = "a" * 26
    long_name_code = Course.new(@attr.merge(:code => long_name))
    long_name_code.should_not be_valid
  end
  
  it "should return full name of the course" do 
    full_course_name = @course.full_name
    full_course_name.should eql("Grade 10 A")
  end
  
  it "should return deactivate course" do 
    @course = Course.new @attr
    @course.inactivate
    @course.is_deleted.should eql(true)
  end
  
  it "has many batches" do
   course_attr = {
      :course_name => "Grade 10",
      :code => "9th",
      :section_name => "A",
      :level      => 2
    }
    batch_attr1 = {
      :name => "c",
      :start_date => 1.year.ago, 
      :end_date => 1.month.ago
    }
    
    batch_attr2 = {
      :name => "d",
      :start_date => 1.year.ago, 
      :end_date => 1.month.ago
    }
    course = Course.new(course_attr)
    batch1=Batch.new(batch_attr1)
    batch2 = Batch.new(batch_attr2)
    course.batches = [batch1,batch2]
    course.save
   end 
   
  it "has many skills" do
   course_attr = {
      :course_name => "Grade 10",
      :code => "9th",
      :section_name => "A",
      :level      => 2
    }
    skill_attr1 = {
      :name => "math",
      
    }
    
    skill_attr2 = {
      :name => "science",
            }
    course = Course.new(course_attr)
    skill1=Skill.new(skill_attr1)
    skill2 = Skill.new(skill_attr2)
    course.skills = [skill1,skill2]
    course.save
   end  
   
   it "has many elective skills" do
   course_attr = {
      :course_name => "Grade 10",
      :code => "9th",
      :section_name => "A",
      :level      => 2
    }
    electiveskill_attr1 = {
      :name => "math",
      
    }
    
    electiveskill_attr2 = {
      :name => "science",
            }
    course = Course.new(course_attr)
    electiveskill1=ElectiveSkill.new(electiveskill_attr1)
    electiveskill2 = ElectiveSkill.new(electiveskill_attr2)
    course.elective_skills = [electiveskill1,electiveskill2]
    course.save
   end  
   
   it "should return all skills related to course" do
     course_attr = {
      :course_name => "Grade 11",
      :code => "10th",
      :section_name => "A",
      :level      => 3
    }
    batch_attr1 = {
      :name => "c",
      :start_date => 1.year.ago, 
      :end_date => 1.month.ago
    }
    skill_attr1 = {
      :name => "10th math",
      :max_weekly_classes => 4,
      :code => '10th math'
    }
    
    skill_attr2 = {
      :name => "10th science",
      :max_weekly_classes => 4,
      :code => '10th science'
            }
    course = Course.new(course_attr)
    batch1=Batch.new(batch_attr1)
    skill1=Skill.create!(skill_attr1)
    skill2 = Skill.create!(skill_attr2)
    course.batches = [batch1]
    course.skills = [skill1,skill2]
    
    course.save!
    course.course_skills(course).count.should eql(2) 
   end
   
   it "should reject duplicate course names" do
   
    course_attr = {
      :course_name => "Grade 9",
      :code => "9th",
      :section_name => "A",
      :level      => 1
    }
    
    batch_attr = {
      :name => "A",
      :start_date => 1.year.ago, 
      :end_date => 1.month.ago
    }
       course = Course.new course_attr
       batch = Batch.new batch_attr   
       course.batches = [batch]  
       course.presence_of_initial_batch
       course.save!
       
       course = Course.new course_attr
       batch = Batch.new batch_attr   
       course.batches = [batch]  
       course.presence_of_initial_batch
       expect {course.save!}.should raise_exception (ActiveRecord::RecordInvalid )    
  end
  
end

  
