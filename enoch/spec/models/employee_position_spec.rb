# == Schema Information
#
# Table name: employee_positions
#
#  id                   :integer         not null, primary key
#  name                 :string(255)
#  employee_category_id :integer
#  status               :boolean
#

require 'spec_helper'



describe EmployeePosition do

  before (:each) do

    employeeCategory = EmployeeCategory.create!(:name => "Mount Carmel Admin",
    :prefix => "Admin",
    :status => true
    )
    @attr = { :name => "Fedena Admin",
      :employee_category_id => employeeCategory.id,
      :status => true
    }
  end
  it "should have a name,employee_category_id,status attributes" do
    employee_position = EmployeePosition.new(@attr)
    employee_position.should respond_to(:name,:employee_category_id,:status)
  end

  it "name should be present" do
    employee_position = EmployeePosition.new(@attr.merge(:name =>""))
    employee_position.should_not be_valid

  end
  it "employee_category_id should be present" do
    employee_position = EmployeePosition.new(@attr.merge(:employee_category_id =>""))
    employee_position.should_not be_valid

  end
  it "should reject duplicate name " do
    employee_position = EmployeePosition.create!(@attr)
    employee_position_with_duplicate_name = EmployeePosition.new(@attr)
    employee_position_with_duplicate_name.should_not be_valid
  end

  it "should pass for scope test" do
    employeeCategory = EmployeeCategory.create!(:name => "Teacher",
    :prefix => "Teach",
    :status => true
    )
    expected_object = EmployeePosition.create!(:name => "demo", :employee_category_id => employeeCategory.id, :status => true)
    active_employee = EmployeePosition.active

    active_employee.should include(expected_object)
  end
  it "employee category has many :employees" do
    expected_object = EmployeePosition.new(@attr)

    expected_object.should respond_to(:employee)
  end

  it "should belongs_to employee_category" do
    expected_object = EmployeePosition.new(@attr)
    expected_object.should respond_to(:employee_category)
  end

end
