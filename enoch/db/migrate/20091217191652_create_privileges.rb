class CreatePrivileges < ActiveRecord::Migration
  def self.up
    create_table :privileges do |t|
      t.string :name
      t.string :description
      t.timestamps
    end
    Privilege.create :name => "ExaminationControl", :description  => "This privilege allows the user to create Exams, Additional Exams, Grading System."
    Privilege.create :name => "EnterResults", :description  => "EnterResults privilege let the user enter marks for Exams and Additional Exams, but not the creation and modification of Exams."
    Privilege.create :name => "ViewResults", :description  => "ViewResults privilege allows the user to just view the examination/assessment reports."
    Privilege.create :name => "Admission", :description  => "This privilege allows the user to admit a new student and modify the details of existing students."
    Privilege.create :name => "StudentsControl", :description  => "This privilege assign gives full control for all the student related processes."
    Privilege.create :name => "StudentAttendanceView", :description  => "This privilege lets user to view the attendance report for any student."
    Privilege.create :name => "HrBasics", :description  => "This privilege allows the user to create and update the employee and leaves."
    Privilege.create :name => "StudentReport", :description  => "This privilege allows the user to view all the student reports"
    Privilege.create :name => "EmployeeProfile", :description  => "EmployeeProfile privilege allows the user to view profile and update his/her own profile."
    Privilege.create :name => "StudentProfile", :description  => "This privilege allows the user to view profile of a student."
    Privilege.create :name => "EventManagement", :description  => "EventManagement privilege allows user to create, modify and delete events from the school calender. This sends out notification messages to the users."
    Privilege.create :name => "SchoolSettings", :description  => "This privilege allows user to access all master information related to school operations."
    Privilege.create :name => "TodayTimetable", :description  => "This privilege allows user to view today time table of whole school."
    Privilege.create :name => "StudentAttendanceRegister", :description  => "This privilege allows user to enter and mdoify student attendance."
    Privilege.create :name => "EmployeeAttendance", :description  => "This privilege allows user to enter, view and modify employee attendance."
    Privilege.create :name => "EmployeeBasicSearch", :description  => "EmployeeBasicSearch privilege, assigned to a user lets the user to view General, Personal and contact information of any employee."
    Privilege.create :name => "EmployeeWiseTimetable", :description  => "This privilege allows user to view timetable for any teacher employee"
    Privilege.create :name => "CourseCreation", :description  => "This privilege allows user to create, edit, delete any course, batch, skill, subskill, topic. The user also has the rights to create subjects for each batch"
    Privilege.create :name => "SmsTemplateCreation", :description  => "This privilege allows user to create, modify and delete sms templates."
    Privilege.create :name => "AssignRollno", :description  => "This privilege allows user to assign roll-numbers to students. The feature to be used by the class teacher, whenever there is a need to re-assign roll-numbers in the class"
    Privilege.create :name => "SmsSettings", :description  => "This privilege allows user to update sms settings."
    Privilege.create :name => "SendingSms", :description  => "This privilege allows user to send sms."
    Privilege.create :name => "Teacher", :description  => "Teacher privilege defines an employee as a teacher, and gives the basic rights for their batches, PTMs, Assignments, timetable."
    Privilege.create :name => "AssignPrivilege", :description  => "AssignPrivilege enables the user to modify privileges for any other user. The user can grant or revoke privileges given to any other user."
    Privilege.create :name => "PtmManagement", :description  => "This privilege allows user to activate and deactivate PTMs."
    Privilege.create :name => "ManageUsers", :description  => "This privilege allows user to reset password of any user. The new password is then sent via registered e-mail"
  end

  def self.down
    drop_table :privileges
  end
end
