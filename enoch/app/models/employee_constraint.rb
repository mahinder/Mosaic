class EmployeeConstraint < ActiveRecord::Base
belongs_to :employee
belongs_to :class_timing
belongs_to :weekday
end
