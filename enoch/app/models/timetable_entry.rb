# == Schema Information
#
# Table name: timetable_entries
#
#  id              :integer         not null, primary key
#  batch_id        :integer
#  weekday_id      :integer
#  class_timing_id :integer
#  subject_id      :integer
#  employee_id     :integer
#

class TimetableEntry < ActiveRecord::Base
  belongs_to :batch
  belongs_to :class_timing
  belongs_to :subject
  belongs_to :employee
  belongs_to :room
  belongs_to :weekday
  def self.time(subject)
    @time = subject.class_timing
  end

  def self.room(subject)
    @subject_room =  RoomsSubject.find_by_subject_id(subject.id)
  end

  def self.employee(subject)
    @employeesubject =  EmployeesSubject.find_by_subject_id(subject.id)
  end

  def self.week_day_entry_find(index,employee)
    timetable_entries = []
    weekday = Weekday.find_by_weekday(index.to_s)
    unless weekday.nil?
      timetable_entries = TimetableEntry.find_all_by_weekday_id_and_employee_id(weekday.id,employee)
    end
    return timetable_entries
  end

  def self.day_find(date,assignteacher)
    total = []
    unless assignteacher.empty?
      assignteacher.each do |tec|
        unless tec.nil? || tec.weekday.nil?

          @timesub = nil
          @today_weekday =  date.wday.to_s
          @date_weekday = tec.weekday.weekday
          if @date_weekday == @today_weekday
            @timesubset = TimetableSubstitution.find_all_by_employee_id_and_subject_id_and_batch_id_and_date(tec.employee.id,tec.subject.id,tec.batch.id,Date.today)
            unless @timesubset.empty?
              @timesubset.each do |sub|
                if sub.class_timing.start_time.to_time == tec.class_timing.start_time.to_time
                @timesub = sub
                end
              end
            end
            if @timesub.nil?
              total = total + [*tec]
            end
          end
        end

      end
    end
    return total
  end

  # week method is not required
  def self.week(time)
    @time = time.weekday.weekday.to_s
    if @time == "0"
      @week = "sun"
    elsif @time == "1"
      @week = "mon"
    elsif @time == "2"
      @week = "tue"
    elsif @time == "3"
      @week = "wed"
    elsif @time == "4"
      @week = "thu"
    elsif @time == "5"
      @week = "fri"
    elsif @time == "6"
      @week = "sat"
    end
    return @week
  end

end