require 'spec_helper'

describe Skill do
  before(:each) do
    @skill_attr = {
      :name => "language",
    }
   @skill=Skill.new(@skill_attr)  
  end
 
 
 it "should have a  name attribute" do
      @skill.should respond_to(:name)
  end
 
 it "should have a course  attribute" do
      @skill.should respond_to(:course)
  end
  
  it "should have a course  attribute" do
      @skill.should respond_to(:elective_skill)
  end
  
 it "should require a  name" do
    no_name = Skill.new(@skill_attr.merge(:name => ""))
    no_name.should_not be_valid
  end
 
 
 
end
