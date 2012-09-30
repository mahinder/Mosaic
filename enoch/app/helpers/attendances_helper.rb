module AttendancesHelper
  def return_student_roll_no batch,date
    unless date.nil?
    period_entry  = PeriodEntry.find_by_month_date_and_batch_id(date.to_date, batch.id)
    else
    period_entry  = PeriodEntry.find_by_month_date_and_batch_id(Date.today, batch.id)  
    end
    attendances = Attendance.find_all_by_period_table_entry_id period_entry.id
        student_roll_no = ""
        attendances.each do |b|
          if student_roll_no == ""
          student_roll_no = student_roll_no + b.student.class_roll_no.to_s
          else
            student_roll_no = student_roll_no+","+ b.student.class_roll_no.to_s
          end
        end
        return student_roll_no
  end
  
  def return_student_roll_no_batch_wise pe,batch
    attendances = Attendance.find_all_by_period_table_entry_id pe.id
        student_roll_no = ""
        attendances.each do |b|
          if student_roll_no == ""
          student_roll_no = student_roll_no + b.student.class_roll_no.to_s
          else
            student_roll_no = student_roll_no+","+ b.student.class_roll_no.to_s
          end
        end
        puts student_roll_no
        return student_roll_no
  end
end
