module ExamGroupsHelper
  def setup_exam_group(exam_group)
    returning(exam_group) do |c|
      c.exams.build if c.exams.empty?
    end
  end

end
