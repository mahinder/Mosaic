class ArchivedAdditionalExamScore < ActiveRecord::Base
   belongs_to :student
  belongs_to :additional_exam
  belongs_to :grading_level
end
