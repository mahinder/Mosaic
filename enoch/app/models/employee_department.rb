class EmployeeDepartment < ActiveRecord::Base
   scope :active, :conditions => { :status => false }, :order => 'name asc'
end
