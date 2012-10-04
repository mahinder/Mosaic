# == Schema Information
#
# Table name: student_categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  is_deleted :boolean         default(FALSE), not null
#

require 'spec_helper'

describe StudentCategory do

  before(:each) do
    @attr = {
      :name => "General",
      :is_deleted => "false"
    }
    
  end 

    after(:each) do
      category = StudentCategory.find_by_name('General')
      category.destroy unless category.nil?
    end

  it "should create a new student category" do
    StudentCategory.create!(@attr)
  end

  it "should require a name" do
    no_name_student_category = StudentCategory.new(@attr.merge(:name => ""))
    no_name_student_category.should_not be_valid
  end

  it "should have a unique name" do
    StudentCategory.create!(@attr)
    duplicate = StudentCategory.new(@attr)
    duplicate.should_not be_valid
  end

  describe "Attribute" do

    before(:each) do
      @student_category = StudentCategory.create!(@attr)
    end

    after(:each) do
      category = StudentCategory.find_by_name('General')
      category.destroy unless category.nil?
    end

    it "should have a name attribute" do
      @student_category.should respond_to(:name)
    end

    it "should have a scope attribute" do
      @student_category.should respond_to(:is_deleted)
    end
    
    it "should have a validate the scope attribute" do
      @student_category = StudentCategory.create!(:name => "demo", :is_deleted => false)
      active_category = StudentCategory.active
      active_category.should include(@student_category)
    end
    
  end

  describe "associations" do

    it "should have a association with students" do
      @student_category = StudentCategory.create!(@attr)
      @student_category.should respond_to(:students)
      @student_category.should respond_to(:fee_category)
      @student_category.should respond_to(:name)
      @student_category.should respond_to(:is_deleted)
    end 

  end
end
