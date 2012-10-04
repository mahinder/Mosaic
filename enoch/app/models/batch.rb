# == Schema Information
#
# Table name: batches
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  course_id   :integer
#  start_date  :datetime
#  end_date    :datetime
#  is_active   :boolean         default(TRUE)
#  is_deleted  :boolean         default(FALSE)
#  employee_id :string(255)
#


class Batch < ActiveRecord::Base
  belongs_to :course
  belongs_to :room
  has_and_belongs_to_many :fee_category , :class_name => "FinanceFeeCategory",:conditions => { :is_deleted => false}
  has_many :students
  has_many :term_masters
  has_many :archived_students
  has_many :student_co_scholastic_assessments
  has_many :grading_levels, :conditions => { :is_deleted => false }
  has_many :subjects, :conditions => { :is_deleted => false }
  has_many :exam_groups
  # has_many :fee_category , :class_name => "FinanceFeeCategory"
  has_many :elective_groups
  has_many :additional_exam_groups
  has_many :finance_fee_collections
  has_many :finance_transactions, :through => :students
  belongs_to :class_teacher ,:class_name => "Employee"
  has_and_belongs_to_many :graduated_students, :class_name => 'Student', :join_table => 'batch_students'
  validates_uniqueness_of :name, :scope => [:course_id,:is_active,:is_deleted]
  delegate :course_name,:section_name, :code, :to => :course
  #validates :name, :start_date, :end_date
  # enoch - change in presence:
  validates :name, :start_date, :end_date, :presence => true 
  validates :name , :length =>{:maximum => 25}
  # enoch - calling validate method
  validate :validate
  scope :active,{ :conditions => { :is_deleted => false, :is_active => true },:joins=>:course,:select=>"`batches`.*,'CONCAT(courses.code,'-',batches.name)' as course_full_name",:order=>"course_full_name"}
  scope :deleted,{:conditions => { :is_deleted => true }, :joins => :course,:select=>"`batches`.*,'CONCAT(courses.code,'-',batches.name)' as course_full_name",:order=>"course_full_name"}
  scope :inactive,{ :conditions => { :is_active => false },:joins=>:course,:select=>"`batches`.*,'CONCAT(courses.code,'-',batches.name)' as course_full_name",:order=>"course_full_name"}
  
  def validate
    errors.add(:start_date, 'should be before end date.') \
      if self.start_date > self.end_date \
      if self.start_date and self.end_date
  end

  def full_name
    "#{code} - #{name}"
  end

  def course_section_name
    "#{course_name} - #{section_name}"
  end
  
  def inactivate
    update_attribute(:is_deleted, true)
    
  end

  def grading_level_list
    levels = self.grading_levels
    levels.empty? ? GradingLevel.find(:all,:conditions => {:is_deleted =>false}) : levels
  end

  def fee_collection_dates
    #FinanceFeeCollection.find_all_by_batch_id(self.id,:conditions => "is_deleted = false")
    # enoch change isdeleted syntex
     FinanceFeeCollection.find_all_by_batch_id(self.id,:conditions => {:is_deleted => false})
  end

  def all_students
    Student.find_all_by_batch_id(self.id)
  end

  def normal_batch_subject
    # Subject.find_all_by_batch_id(self.id,:conditions =>["elective_group_id IS NULL AND is_deleted = 'f'"])
    # enoch change isdeleted syntex
    Subject.find_all_by_batch_id(self.id,:conditions =>["elective_group_id IS NULL AND is_deleted = 'f'"])
  end
  
  def elective_batch_subject(elect_group) 
    Subject.find_all_by_batch_id_and_elective_group_id(self.id,elect_group,:conditions=>["elective_group_id IS NOT NULL AND is_deleted = 'f'"])
  end
  
  def time_entry(subject)
   TimetableEntry.find_all_by_batch_id_and_subject_id(self.id,subject.id)
  end
  
end
