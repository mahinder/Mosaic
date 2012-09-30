# == Schema Information
#
# Table name: sms_settings
#
#  id           :integer         not null, primary key
#  settings_key :string(255)
#  is_enabled   :boolean         default(FALSE)
#

class SmsSetting < ActiveRecord::Base
  include SmsManagerHelper
  def application_sms_active
    application_sms = SmsSetting.find_by_settings_key("ApplicationEnabled")
    return true if application_sms.is_enabled
  end

  def student_sms_active
    student_sms = SmsSetting.find_by_settings_key("StudentSmsEnabled")
    return true if student_sms.is_enabled
  end

  def additional_exam_result_schedule_sms_active
    additional_exam_sms = SmsSetting.find_by_settings_key("AdditionalExamScheduleResultEnabled")
    return true if additional_exam_sms.is_enabled
  end
  def admission_sms_active
    admission_sms = SmsSetting.find_by_settings_key("StudentAdmissionEnabled")
    return true if admission_sms.is_enabled
  end

  def employee_sms_active
    employee_sms = SmsSetting.find_by_settings_key("EmployeeSmsEnabled")
    return true if employee_sms.is_enabled
  end

  def attendance_sms_active
    attendance_sms = SmsSetting.find_by_settings_key("AttendanceEnabled")
    return true if attendance_sms.is_enabled
  end

  def ptm_sms_active
    ptm_sms = SmsSetting.find_by_settings_key("PtmEnabled")
    return true if ptm_sms.is_enabled
  end
  def event_news_sms_active
    event_news_sms = SmsSetting.find_by_settings_key("NewsEventsEnabled")
    return true if event_news_sms.is_enabled
  end

  def exam_result_schedule_sms_active
    result_schedule_sms = SmsSetting.find_by_settings_key("ExamScheduleResultEnabled")
    return true if result_schedule_sms.is_enabled
  end

  def create_recipient(phone_no,recipients)
    unless phone_no.nil?
      if recipients.nil?
        recipients = phone_no
      else
        recipients = recipients + "," + phone_no
      end
    end
    return recipients
  end

  def send_sms(message,recipients)
    begin
       unless recipients.nil?
          sms = SmsManager.new(message,recipients)
          sms. send_sms
      end
    rescue Exception => exc
      return "something went worng"
    end   
     
  end

end
