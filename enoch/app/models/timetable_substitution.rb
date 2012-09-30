class TimetableSubstitution < ActiveRecord::Base
  belongs_to :batch
   belongs_to :subject
    belongs_to :employee
     belongs_to :teacher_substitude_with ,:class_name => "Employee"
      belongs_to :class_timing
end
