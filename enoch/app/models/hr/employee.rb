# == Schema Information
#
# Table name: employees
#
#  id                     :integer         not null, primary key
#  employee_category_id   :integer
#  employee_number        :string(255)
#  joining_date           :date
#  first_name             :string(255)
#  middle_name            :string(255)
#  last_name              :string(255)
#  gender                 :boolean
#  job_title              :string(255)
#  employee_position_id   :integer
#  employee_department_id :integer
#  reporting_manager_id   :integer
#  employee_grade_id      :integer
#  qualification          :string(255)
#  experience_detail      :text
#  experience_year        :integer
#  experience_month       :integer
#  status                 :boolean
#  status_description     :string(255)
#  date_of_birth          :date
#  marital_status         :string(255)
#  children_count         :integer
#  father_name            :string(255)
#  mother_name            :string(255)
#  husband_name           :string(255)
#  blood_group            :string(255)
#  nationality_id         :integer
#  home_address_line1     :string(255)
#  home_address_line2     :string(255)
#  home_city              :string(255)
#  home_state             :string(255)
#  home_country_id        :integer
#  home_pin_code          :string(255)
#  office_address_line1   :string(255)
#  office_address_line2   :string(255)
#  office_city            :string(255)
#  office_state           :string(255)
#  office_country_id      :integer
#  office_pin_code        :string(255)
#  office_phone1          :string(255)
#  office_phone2          :string(255)
#  mobile_phone           :string(255)
#  home_phone             :string(255)
#  email                  :string(255)
#  fax                    :string(255)
#  photo_file_name        :string(255)
#  photo_content_type     :string(255)
#  photo_data             :binary(5242880)
#  created_at             :datetime
#  updated_at             :datetime
#  photo_file_size        :integer
#  user_id                :integer
#

class Employee < ActiveRecord::Base
  
   # puts Course.report_table.to_csv
  has_attached_file :employee_photo, :styles => { :small  => "50x50#" ,:large => "500x500>"}, :processors => [:cropper]
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_employee_photo, :if => :cropping?
  attr_accessible :general, :personal,:address, :user_name, :employee_number,:first_name, :last_name, :joining_date,:experience_year,:experience_month,
  :experience_info,:status,:status_description,:email,:employee_grade_id,:gender,:home_country_id,:office_country_id,:date_of_birth,:marital_status,
  :employee_category_id, :employee_department_id, :employee_position_id, :reporting_manager_id, :shift_start_time, :shift_end_time, :employee_photo_file_name,
  :employee_photo_content_type,:employee_photo_data,:employee_photo_file_size,:employee_photo, :skill_ids, :crop_x, :crop_y, :crop_w, :crop_h, :middle_name, :blood_group,:father_name,:mother_name,
  :husband_name,:qualification, :children_count, :home_address_line1,:home_address_line2,:home_state,:home_city,:home_pin_code,:office_address_line1,:office_address_line2,
  :office_state,:office_city,:office_pin_code,:office_phone1,:office_phone2,:mobile_phone,:home_phone,:nationality_id,:is_teacher,:experience_detail,:fax,:is_transport_enabled
  attr_writer :current_step
  belongs_to  :employee_category
  belongs_to  :employee_position
  belongs_to  :employee_grade
 
  belongs_to  :employee_department
  belongs_to  :nationality, :class_name => 'Country'
  belongs_to  :user, :dependent=>:destroy,:autosave=>true
  # has_many    :employees_subjects
  # has_many    :subjects ,:through => :employees_subjects
  has_many    :timetable_entries
  has_many    :employee_bank_details
  has_many    :employee_additional_details
  has_many    :apply_leaves
  has_many    :monthly_payslips
  has_many    :employee_salary_structures
  has_many    :finance_transactions, :as => :payee
  has_many    :teacher_diaries
  # validates_presence_of :general, :if => lambda { |o| o.current_step == "general" }
  # validates_presence_of :billing_name, :if => lambda { |o| o.current_step == "personal" }

  validates_format_of     :email, :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,   :allow_blank=>true, 
    :message => "must be a valid email address"
  validates :email, :uniqueness => true
  validates :employee_number,:first_name, :joining_date, :date_of_birth, :presence => true, :if => lambda { |o| o.current_step == "general" }
  validates :employee_category_id, :employee_position_id,:employee_department_id, :presence => true, :if => lambda { |o| o.current_step == "personal" }
  # validates :employee_category_id, :employee_number, :first_name, :employee_position_id,:employee_department_id,  :date_of_birth, :presence => true
  validates  :employee_number, :uniqueness => {:case_sensitive => false}

  has_and_belongs_to_many :skills
  has_and_belongs_to_many :subjects
  validates_associated :user
  before_validation :create_user_and_validate
validate :validate
def validate
    unless self.shift_start_time.nil? or self.shift_end_time.nil?
      errors.add(:shift_end_time,"can not be before the shift start time")if self.shift_end_time < self.shift_start_time
      errors.add(:shift_end_time,"can not be equal to the shift start time")if self.shift_end_time == self.shift_start_time
    end

  end
  def create_user_and_validate
    self.email ||="#{self.first_name.gsub(/ /,'')}" + self.employee_number.to_s + "@ezzie.in"
    if self.new_record?
      user_record = self.build_user
      user_record.first_name = self.first_name
      user_record.last_name = self.last_name
      user_record.username = self.employee_number.to_s
      if self.employee_number == 'admin'
        user_record.password = "P@ssw0rd"
      else
        user_record.password = "password"#self.employee_number.to_s + "123"
      end
      user_record.role = 'Employee'
      user_record.email = self.email.blank? ? "noreply#{self.employee_number.to_s}@ezzie.in" : self.email.to_s
      check_user_errors(user_record)
    else
      self.user.role = "Employee"
      changes_to_be_checked = ['employee_number','first_name','last_name','email']
      check_changes = self.changed & changes_to_be_checked
      unless check_changes.blank?
        self.user.username = self.employee_number if check_changes.include?('employee_number')
        self.user.first_name = self.first_name if check_changes.include?('first_name')
        self.user.last_name = self.last_name if check_changes.include?('last_name')
        self.user.email ||= self.email.to_s if check_changes.include?('email')
        check_user_errors(self.user)
      end
    end
  end

  def check_user_errors(user)
    unless user.valid?
      user.errors.each{|attr,msg| errors.add(attr.to_sym,"#{msg}")}
    end
    return false unless user.errors.blank?
    # enoch - change to return true
    return true
  end

  def self.birth_day_message_to_all
    @user = User.find_by_id(1)
    unless @user.nil?
      @employee_birth_day = Employee.find(:all, :conditions => ["Dayofmonth(date_of_birth) = Dayofmonth(curdate()) and month(date_of_birth) = month(curdate())"])
        unless @employee_birth_day.nil?
          @employee_birth_day.each do |s|
           reminder = Reminder.create(:sender=> @user.id,:sent_to => "#{s.full_name}",  
                :subject=>"Happy Birth Day",
                      :body=>"Wish You a very Happy Birth Day #{s.full_name} ")
                  employee_user = s.user
                  ReminderRecipient.create(:recipient=>employee_user.id,:reminder_id => reminder.id)
           end
         end
        @student_birth_day = Student.find(:all, :conditions => ["Dayofmonth(date_of_birth) = Dayofmonth(curdate()) and month(date_of_birth) = month(curdate())"])
        unless @student_birth_day.nil?
          @student_birth_day.each do |s|
           reminder = Reminder.create(:sender=> @user.id,:sent_to => "#{s.full_name}",  
                :subject=>"Happy Birth Day",
                      :body=>"Wish You a very Happy Birth Day #{s.full_name} ")
                  student_user = s.user
                  ReminderRecipient.create(:recipient=>student_user.id,:reminder_id => reminder.id)
           end
         end
     end
  end

  def image_file=(input_data)
    return if input_data.blank?
    self.employee_photo_filename     = input_data.original_filename
    self.employee_photo_content_type = input_data.content_type.chomp
    self.employee_photo_data         = input_data.read
  end

  def max_hours_per_day
    self.employee_grade.max_hours_day unless self.employee_grade.blank?
  end

  def max_hours_per_week
    self.employee_grade.max_hours_week unless self.employee_grade.blank?
  end

  def next_employee
    next_st = self.employee_department.employees.first(:conditions => "id>#{self.id}",:order => "id ASC")
    next_st ||= employee_department.employees.first(:order => "id ASC")
    next_st ||= self.employee_department.employees.first(:order => "id ASC")
  end

  def previous_employee
    prev_st = self.employee_department.employees.first(:conditions => "id<#{self.id}",:order => "id DESC")
    prev_st ||= employee_department.employees.first(:order => "id DESC")
    prev_st ||= self.employee_department.empoyees.first(:order => "id DESC")
  end

  def full_name
    "#{first_name} #{middle_name} #{last_name}"
  end

 

  def is_payslip_approved(date)
    # enoch - change syantex is_approved 't'
    approve = MonthlyPayslip.find_all_by_salary_date_and_employee_id(date,self.id,:conditions => ["is_approved = 't'"])
    if approve.empty?
    return false
    else
    return true
    end
  end

  def is_payslip_rejected(date)
    # enoch - change syantex is_approved 't'
    approve = MonthlyPayslip.find_all_by_salary_date_and_employee_id(date,self.id,:conditions => ["is_rejected = 't'"])
    if approve.empty?
    return false
    else
    return true
    end
  end

  def self.total_employees_salary(employees,start_date,end_date)
    salary = 0
    employees.each do |e|
      salary_dates = e.all_salaries(start_date,end_date)
      salary_dates.each do |s|
        salary += e.employee_salary(s.salary_date.to_date)
      end
    end
    salary
  end

  def employee_salary(salary_date)

    monthly_payslips = MonthlyPayslip.find(:all,
    :order => 'salary_date desc',
    :conditions => ["employee_id ='#{self.id}'and salary_date = '#{salary_date}' and is_approved = 1"])
    individual_payslip_category = IndividualPayslipCategory.find(:all,
    :order => 'salary_date desc',
    :conditions => ["employee_id ='#{self.id}'and salary_date >= '#{salary_date}'"])
    individual_category_non_deductionable = 0
    individual_category_deductionable = 0
    individual_payslip_category.each do |pc|
      unless pc.is_deduction == true
      individual_category_non_deductionable = individual_category_non_deductionable + pc.amount.to_f
      end
    end
    individual_category_non_deductionable

    individual_payslip_category.each do |pc|
      unless pc.is_deduction == false
      individual_category_deductionable = individual_category_deductionable + pc.amount.to_f
      end
    end
    individual_category_deductionable
    non_deductionable_amount = 0
    deductionable_amount = 0
    monthly_payslips.each do |mp|
      category1 = PayrollCategory.find(mp.payroll_category_id)
      unless category1.is_deduction == true
      non_deductionable_amount = non_deductionable_amount + mp.amount.to_f
      end
    end

    monthly_payslips.each do |mp|
      category2 = PayrollCategory.find(mp.payroll_category_id)
      unless category2.is_deduction == false
      deductionable_amount = deductionable_amount + mp.amount.to_f
      end
    end
    net_non_deductionable_amount = individual_category_non_deductionable + non_deductionable_amount
    net_deductionable_amount = individual_category_deductionable + deductionable_amount

    net_amount = net_non_deductionable_amount - net_deductionable_amount
    return net_amount.to_f
  end

  def salary(start_date,end_date)
    MonthlyPayslip.find_by_employee_id(self.id,:order => 'salary_date desc',
    #:conditions => ["salary_date >= '#{start_date.to_date}' and salary_date <= '#{end_date.to_date}' and is_approved = 1"]).salary_date
    # enoch -  syntex change of writing the condition
    :conditions =>[" '#{end_date.to_date}'<= salary_date <= '#{start_date.to_date}' and is_approved ='t' "]).salary_date
  end

  def archive_employee(status)
    self.update_attributes(:status => false, :status_description => status)
    employee_attributes = self.attributes
    employee_attributes.delete "id"
    employee_attributes.delete "employee_photo_file_size"
    employee_attributes.delete "employee_photo_file_name"
    employee_attributes.delete "employee_photo_content_type"
    employee_attributes.delete "user_id"
    employee_attributes["former_id"]= self.id
    archived_employee = ArchivedEmployee.new(employee_attributes)
    archived_employee.employee_photo = self.employee_photo
    if archived_employee.save
      self.user.delete unless self.user.nil?
      employee_salary_structures = self.employee_salary_structures
      employee_bank_details = self.employee_bank_details
      employee_additional_details = self.employee_additional_details
      employee_salary_structures.each do |g|
        g.archive_employee_salary_structure(archived_employee.id)
      end
      employee_bank_details.each do |g|
        g.archive_employee_bank_detail(archived_employee.id)
      end
      employee_additional_details.each do |g|
        g.archive_employee_additional_detail(archived_employee.id)
      end
    self.user.delete
    self.delete
    end
  end

  def all_salaries(start_date,end_date)
    MonthlyPayslip.find_all_by_employee_id(self.id,:select =>"distinct salary_date" ,:order => 'salary_date desc',
    :conditions => ["salary_date >= '#{start_date.to_date}' and salary_date <= '#{end_date.to_date}' and is_approved = 't'"])
  end

  def self.calculate_salary(monthly_payslip,individual_payslip_category)
    individual_category_non_deductionable = 0
    individual_category_deductionable = 0
    unless individual_payslip_category.blank?
      individual_payslip_category.each do |pc|
        if pc.is_deduction == true
        individual_category_deductionable = individual_category_deductionable + pc.amount.to_f
        else
        individual_category_non_deductionable = individual_category_non_deductionable + pc.amount.to_f
        end
      end
    end
    non_deductionable_amount = 0
    deductionable_amount = 0
    unless monthly_payslip.blank?
      monthly_payslip.each do |mp|
        unless mp.payroll_category.blank?
          if mp.payroll_category.is_deduction == true
          deductionable_amount = deductionable_amount + mp.amount.to_f
          else
          non_deductionable_amount = non_deductionable_amount + mp.amount.to_f
          end
        end
      end
    end
    net_non_deductionable_amount = individual_category_non_deductionable + non_deductionable_amount
    net_deductionable_amount = individual_category_deductionable + deductionable_amount
    net_amount = net_non_deductionable_amount - net_deductionable_amount

    return_hash = {:net_amount=>net_amount,:net_deductionable_amount=>net_deductionable_amount,\
      :net_non_deductionable_amount=>net_non_deductionable_amount }
    return_hash
  end

  def self.find_in_active_or_archived(id)
    employee = Employee.find(:first,:conditions=>"id=#{id}")
    if employee.blank?
      return  ArchivedEmployee.find(:first,:conditions=>"former_id=#{id}")
    else
    return employee
    end
  end

  def current_step
    @current_step || steps.first
  end

  def steps
    # %w[general personal demo address image_upload] #partial names to be used in view
    %w[summary professional personal contact photo photo_crop] #partial names to be used in view
  end

  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end

  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def employee_photo_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(employee_photo.path(style))
  end

  def employee_batch(current_user,batch)
    @courses = []
    @batches = []
    @current_user = current_user
    @employee  = Employee.find_by_employee_number(@current_user.username)
    @skills = @employee.skills if !@employee.nil?
    unless @skills.nil?
      @skills.each do |skill|
        @courses = @courses + [*skill.course]
      end
    end
    @home_class = Batch.find_by_class_teacher_id(@employee.id)

    unless @courses.nil?
      @courses.each do |course|
        course.batches.each do |batch|
          @batches = @batches + [*batch]
        end
      end
    end
    if !@home_class.nil? and !@batches.nil?
      @val = @batches.include? @home_class

      if @val == false
        @batches = @batches + [*@home_class]
      end
      @valbatch = @batches.include? batch
      if @valbatch == false
        @batches = @batches + [*batch]
      else
        @batches = @batches - [*batch]
        @batches = @batches + [*batch]
      end
    end

    return @batches
  end

def self.save(upload,current_user)
   begin
    collation = upload['datafilecol'].to_i
   # attachment_content_type = upload['datafile'].content_type
    attachment_emp_id = upload['employee_id']
    attachment_addmission = upload['addmision']
    Dir.mkdir("#{Rails.root}/public/system")unless Dir.exists?("#{Rails.root}/public/system")
    Dir.mkdir("#{Rails.root}/public/system/attachment")unless Dir.exists?("#{Rails.root}/public/system/attachment")
    Dir.mkdir("#{Rails.root}/public/system/attachment/employee")unless Dir.exists?("#{Rails.root}/public/system/attachment/employee")
    Dir.mkdir("#{Rails.root}/public/system/attachment/employee/#{attachment_emp_id}")unless Dir.exists?("#{Rails.root}/public/system/attachment/employee/#{attachment_emp_id}")
    Dir.mkdir("#{Rails.root}/public/system/attachment/employee/#{attachment_emp_id}/#{upload[:value]}")unless Dir.exists?("#{Rails.root}/public/system/attachment/employee/#{attachment_emp_id}/#{upload[:value]}")
    directory = "#{Rails.root}/public/system/attachment/employee/#{attachment_emp_id}/#{upload[:value]}"
    index = 1
    collation.times do |i|
       name = 'datafile'+ index.to_s
       puts name
       attachment_filename = upload[name].original_filename
       unless File.exists?("#{Rails.root}/public/system/attachment/employee/#{attachment_emp_id}/#{upload[:value]}/#{attachment_filename}")
          EmployeeAttachment.create!(:dir_name => "#{upload[:value]}",:employee_id => attachment_emp_id ,:file_name => attachment_filename,:created_by_id => current_user.id)
       end
       path = directory+"/"+attachment_filename
       File.open(path, "wb") { |f| f.write(upload[name].read) }
        index = index + 1
    end
    
    rescue Exception => e
      return false
    end
    
    return true
    
    # write the file
    
  end



  private

  def reprocess_employee_photo
    employee_photo.reprocess!
  end
end