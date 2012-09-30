module EmployeeAttendancesHelper

  def attendance_date(report)
      if report.count <= 3 
        @show=  report[0..report.count] 
        @hiddenEvent =  nil
      else
        @show =  report[0..2]
        @hiddenEvent =  report[3..report.count] 
      end
  end
end