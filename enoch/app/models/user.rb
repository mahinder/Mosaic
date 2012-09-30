# == Schema Information
#
# Table name: users
#
#  id                        :integer         not null, primary key
#  username                  :string(255)
#  first_name                :string(255)
#  last_name                 :string(255)
#  email                     :string(255)
#  admin                     :boolean
#  student                   :boolean
#  employee                  :boolean
#  hashed_password           :string(255)
#  salt                      :string(255)
#  reset_password_code       :string(255)
#  reset_password_code_until :datetime
#  created_at                :datetime
#  updated_at                :datetime
#

class User < ActiveRecord::Base

  attr_accessor :password, :role, :old_password, :new_password, :confirm_password

  # validates :username, :email ,:uniqueness => true
  # validates_length_of     :username, :within => 1..20
  # validates_length_of     :password, :within => 4..40, :allow_nil => true
  # validates_format_of     :username, :with => /^[A-Z0-9_-]*$/i,
  # :message => "must contain only letters, numbers, and underscores"
  # validates_format_of     :email, :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,
  # :message => "must be a valid email address"
  # validates   :role , :on=>:create
  # validates   :email, :on=>:create
  # validates   :password, :on => :create
  # enoch - change syntex
  validates :username, :email ,:uniqueness => true, :presence => true
  validates :username, length: { :within => 1..20 }
  validates :password, length:{:within => 4..40}, :allow_nil => true
  validates :username, format: {:with => /^[A-Z0-9_-]*$/i,
  :message => "must contain only letters, numbers, and underscores"}
  validates :email,     format: {:with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
  :message => "must be a valid email address"}
  validates   :role , :on=>:create, :presence => true
  validates   :email, :on=>:create, :presence => true
  validates   :password, :on => :create, :presence => true

  has_and_belongs_to_many :privileges

  has_one :student_record, class_name:"Student", :foreign_key=>"user_id"
  has_one :employee_record, class_name:"Employee", :foreign_key=>"user_id"
  has_one :timetable_record, class_name:"TimetableUser", :foreign_key=>"user_id"
  before_save :create_user
  def create_user
    self.salt = random_string(8) if self.salt == nil
    self.hashed_password = Digest::SHA1.hexdigest(self.salt + self.password) unless self.password.nil?
    self.admin, self.employee, self.student = false, false, false
    self.admin = true if self.role == "Admin"
    self.employee = true if self.role == "Employee"
    self.student = true if self.role == "Student"
    self.timetable = true if self.role == "Timetable"
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def check_reminders
    reminders =[]
    reminders = ReminderRecipient.find(:all , :conditions => {:recipient => self.id ,:is_deleted_by_recipient => false})
    count = 0
    reminders.each do |r|
      unless r.is_read
      count += 1
      end
    end
    return count
  end

  class << self
    def authenticate?(username, password)
      user = User.find_by_username username
      (user && user.hashed_password == Digest::SHA1.hexdigest(user.salt + password)) ? user : nil
    end
    def build_xml(grades)
    buffer=""
    xm=Builder::XmlMarkup.new()
    xm.instruct! 
    buffer += xm.grades do
        grades.each do |c|
            puts "c is#{c.first_name}"
        end
    end
    return buffer
end

  end

  def random_string(len)
    randstr = ""
    chars = ("0".."9").to_a + ("a".."z").to_a + ("A".."Z").to_a
    len.times { randstr << chars[rand(chars.size - 1)] }
    randstr
  end

  def role_name
    return "Admin" if self.admin?
    return "Student" if self.student?
    return "Employee" if self.employee?
    return "Timetable" if self.timetable?
    return nil

  end

  def role_symbols
    prv = []
    @privilge_symbols ||= privileges.map { |privilege| prv << privilege.name.underscore.to_sym }

    if admin?
      return [:admin] + prv
    elsif student?
      return [:student] + prv
    elsif employee?
      return [:employee] + prv
    elsif timetable?
      return [:timetable] + prv
    else
    return prv
    end
  end

  def retrieve_top_three_reminders
    reminders =[]
    reminders = ReminderRecipient.find(:all , :conditions => ["recipient = '#{self.id}' and is_deleted_by_recipient = 'f'"], :limit => 3, :order => 'created_at DESC')
    top_reminders = []
    count = 0
    reminders.each do |r|
      unless r.is_read
      top_reminders[count] = r
      count += 1
      end
    end
    return top_reminders
  end
end
