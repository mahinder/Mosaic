# == Schema Information
#
# Table name: employee_categories
#
#  id     :integer         not null, primary key
#  name   :string(255)
#  prefix :string(255)
#  status :boolean
#

require 'spec_helper'
describe EmployeeCategory do
  before (:all) do
     @attr = { :name => "Mount Carmel Admin",
       :prefix => "Admin",
       :status => true
     }
   end
  
   # it "should create a new instance given a valid attribute" do
     # EmployeeCategory.create!(@attr)
   # end
    it "should have a name,prefix,status attributes" do
      @employee_cateogory = EmployeeCategory.new(@attr)
      @employee_cateogory.should respond_to(:name,:prefix,:status)
    end
    it "name should be present" do
    @employee_cateogory = EmployeeCategory.new(:name =>"" ,
       :prefix => "Admin",
       :status => true )
      @employee_cateogory.should_not be_valid
      
    end
    it "prefix should be present" do
    @employee_cateogory = EmployeeCategory.new(:name =>"Teacher" ,
       :prefix => "",
       :status => true )
      @employee_cateogory.should_not be_valid
      
    end
    it "should reject duplicate name " do
      employee_cateogory1 = EmployeeCategory.create!(@attr)
        employee_cateogory_with_duplicate_name = EmployeeCategory.new(@attr)
       employee_cateogory_with_duplicate_name.should_not be_valid
   end
    it "employee_category name should be identical in each case" do
    upcased_name = @attr[:name].upcase 
    EmployeeCategory.create!(@attr.merge(:name => upcased_name))
    Employee_Category_with_duplicate_name = EmployeeCategory.new(@attr)
    Employee_Category_with_duplicate_name.should_not be_valid
  end
   it "should reject duplicate prefix " do
      employee_cateogory1 = EmployeeCategory.create!(@attr.merge(:name => "data", :prefix => "dat", :status => true))
        employee_cateogory_with_duplicate_prefix = EmployeeCategory.new(:name => "date", :prefix => "dat", :status => true)
       employee_cateogory_with_duplicate_prefix.should_not be_valid
   end
   it "employee_category prefix should be identical in each case" do
     
    upcased_prefix = @attr[:prefix].downcase
    EmployeeCategory.create!(@attr.merge(:prefix => upcased_prefix))
    Employee_Category_with_duplicate_prefix = EmployeeCategory.new(@attr) 
    Employee_Category_with_duplicate_prefix.should_not be_valid
  end
   it "should pass for scope test" do
      
    expected_object = EmployeeCategory.create!(:name => "demo", :prefix => "de", :status => true)
    active_employee = EmployeeCategory.active
    
   active_employee.should include(expected_object) 
   end
   
   it "employee category has many :employee_positions" do
   expected_object = EmployeeCategory.create!(:name => "demo", :prefix => "de", :status => true)
   expected_object.should respond_to(:employee_positions)
   end
   it "employee category has many :employees" do
   expected_object = EmployeeCategory.create!(:name => "demo", :prefix => "de", :status => true)
  

  expected_object.should respond_to(:employees)
   end
  
 end
