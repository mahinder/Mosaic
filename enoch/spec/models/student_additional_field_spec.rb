require 'spec_helper'

describe StudentAdditionalField do

before(:each) do
      @attr = {
      :name => "Passport",
      :status => "true"
    }
end

  it "should create a new student additional field" do
    StudentAdditionalField.create!(@attr)
  end
  
  it "should require a name" do
    no_name_student_additional_field = StudentAdditionalField.new(@attr.merge(:name => ""))
    no_name_student_additional_field.should_not be_valid
  end

  it "should create a new student additional field for uniqueness case sensitive false" do
    student_additional_field = StudentAdditionalField.create!(@attr)
    another_student_additional_field = StudentAdditionalField.new(@attr.merge(:name => "passport", :status => true))
    another_student_additional_field.should_not be_valid
  end

  it "should have a unique name" do
    StudentAdditionalField.create!(@attr)
    duplicate = StudentAdditionalField.new(@attr)
    duplicate.should_not be_valid
  end
  
 describe "Attribute" do

    before(:each) do
      @student_additional_field = StudentAdditionalField.create!(@attr)
    end

    after(:each) do
      category = StudentAdditionalField.find_by_name('Passport')
      category.destroy unless category.nil?
    end

    it "should have a name attribute" do
      @student_additional_field.should respond_to(:name)
    end
    
    it "should have a validate the scope attribute" do
      @student_additional_field = StudentAdditionalField.create!(:name => "demo", :status => true)
      long = "a" * 60
      name_length = @attr.merge(:name => long)
      StudentAdditionalField.new(name_length).should_not be_valid
    end   
  end   
end
