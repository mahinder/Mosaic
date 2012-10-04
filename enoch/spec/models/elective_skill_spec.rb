require 'spec_helper'

describe ElectiveSkill do
 
 before(:each) do
    @electiveskill_attr = {
      :name => "language",
    }
   @electives=ElectiveSkill.new(@electiveskill_attr)  
  end
 
 
 it "should have a course name attribute" do
      @electives.should respond_to(:name)
  end
 
 it "should have a course  attribute" do 
      @electives.should respond_to(:course)
  end
 it "should require a  name" do
    no_name = ElectiveSkill.new(@electiveskill_attr.merge(:name => ""))
    no_name.should_not be_valid
  end
 
 
 it "has many skills" do
   electiveskill_attr1 = {
      :name => "math",
    }
    skill_attr1 = {
      :name => "math",
    }
    skill_attr2 = {
      :name => "science",
            }
    electiveskill=ElectiveSkill.new(electiveskill_attr1)
    skill1=Skill.new(skill_attr1)
    skill2 = Skill.new(skill_attr2)
    electiveskill.skills = [skill1,skill2]
    electiveskill.save
   end  
 
 
 
end
