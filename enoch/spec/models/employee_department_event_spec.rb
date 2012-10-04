# == Schema Information
#
# Table name: employee_department_events
#
#  id                     :integer         not null, primary key
#  event_id               :integer
#  employee_department_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

require 'spec_helper'



describe EmployeeDepartmentEvent do
  before(:each) do
    employee_department = EmployeeDepartment.create!(:code => 'MGMT',:name => 'Management', :status => true)
    event = Event.create!(:title => "musical", :description => "description", :start_date => Date.today-4, :end_date => Date.today-2)
    @employee_department_event_attr = {
      :employee_department => employee_department,
      :event => event
    }
  end
  it "should exist" do
    employee_department_event = EmployeeDepartmentEvent.new(@employee_department_event_attr)
    employee_department_event.should be_valid
  end
  it "should respond to employee deoartment" do
    employee_department_event = EmployeeDepartmentEvent.new(@employee_department_event_attr)
    employee_department_event.should respond_to(:employee_department)
  end
  it "should respond to event" do
    employee_department_event = EmployeeDepartmentEvent.new(@employee_department_event_attr)
    employee_department_event.should respond_to(:event)
  end
end
