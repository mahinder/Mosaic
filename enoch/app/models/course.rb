# == Schema Information
#
# Table name: courses
#
#  id           :integer         not null, primary key
#  course_name  :string(255)
#  code         :string(255)
#  section_name :string(255)
#  is_deleted   :boolean         default(FALSE)
#  created_at   :datetime
#  updated_at   :datetime
#



class Course < ActiveRecord::Base
  
  
  validates  :course_name, :code, :level, :presence =>true
  validates  :level, :uniqueness => true 
  validate :presence_of_initial_batch, :on => :create
  validates :course_name , :length =>{:maximum => 50}
  validates :code, :length =>{:maximum => 25}
  validates :section_name , :length =>{:maximum => 50}
  validates_uniqueness_of :course_name, :scope => :is_deleted
  # validates :level, :length =>{:minimum => -3 , :maximum => 20} , :allow_nil => false
  validates_inclusion_of :level, :in => -3..20, :message => "value must be less than 20 and greater than -3"
  has_many :elective_skills
  has_many :batches
  has_many :skills
  accepts_nested_attributes_for :batches
  has_and_belongs_to_many :co_scholastic_areas
  has_and_belongs_to_many :co_scholastic_activities
  scope :active, :conditions => { :is_deleted => false }, :order => 'id asc'
  scope :deleted, :conditions => { :is_deleted => true }, :order => 'id asc'
  
  def presence_of_initial_batch
    errors[:base] = "Should have an initial batch" if batches.length == 0
  end

  def inactivate
    update_attribute(:is_deleted, true)
  end
  
  def full_name
    "#{course_name} #{section_name}"
  end

  def course_skills(course)
    skills = Skill.find(:all,:conditions => {:course_id => course , :elective_skill_id => nil})
    
  end
#  def guardian_email_list
#    email_addresses = []
#    students = self.students
#    students.each do |s|
#      email_addresses << s.immediate_contact.email unless s.immediate_contact.nil?
#    end
#    email_addresses
#  end
#
#  def student_email_list
#    email_addresses = []
#    students = self.students
#    students.each do |s|
#      email_addresses << s.email unless s.email.nil?
#    end
#    email_addresses
#  end

end
