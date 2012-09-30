# == Schema Information
#
# Table name: students
#
#  id                   :integer         not null, primary key
#  admission_no         :string(255)
#  class_roll_no        :string(255)
#  admission_date       :date
#  first_name           :string(255)
#  middle_name          :string(255)
#  last_name            :string(255)
#  batch_id             :integer
#  date_of_birth        :date
#  gender               :string(255)
#  blood_group          :string(255)
#  birth_place          :string(255)
#  nationality_id       :integer
#  language             :string(255)
#  religion             :string(255)
#  student_category_id  :integer
#  address_line1        :string(255)
#  address_line2        :string(255)
#  city                 :string(255)
#  state                :string(255)
#  pin_code             :string(255)
#  country_id           :integer
#  phone1               :string(255)
#  phone2               :string(255)
#  email                :string(255)
#  immediate_contact_id :integer
#  is_sms_enabled       :boolean         default(TRUE)
#  student_photo_file_name      :string(255)
#  student_photo_content_type   :string(255)
#  student_photo_data           :binary(76800)
#  status_description   :string(255)
#  is_active            :boolean         default(TRUE)
#  is_deleted           :boolean         default(FALSE)
#  created_at           :datetime
#  updated_at           :datetime
#  has_paid_fees        :boolean         default(FALSE)
#  photo_file_size      :integer
#  user_id              :integer
#

class Student < ActiveRecord::Base
  belongs_to :country
  belongs_to :batch
  belongs_to :student_category
  belongs_to :nationality, :class_name => 'Country'
  belongs_to :user, :dependent=>:destroy, :autosave => true
  attr_writer :current_step
  has_one    :immediate_contact
  has_one    :student_previous_data
  has_many   :student_previous_subject_mark
  has_many   :guardians, :foreign_key => 'ward_id', :dependent => :destroy
  has_many   :finance_transactions, :as => :payee
  has_many   :attendances
  has_many   :finance_fees
  has_many   :fee_category, :class_name => "FinanceFeeCategory"
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :reprocess_student_photo, :if => :cropping?
  has_and_belongs_to_many :graduated_batches, :class_name => 'Batch', :join_table => 'batch_students'

  scope :active, :conditions => { :is_active => true }
  validates :admission_no,:first_name,:last_name,:length => { :minimum => 1, :maximum => 50 },:if => lambda { |o| o.current_step == "personal" }
  validates :admission_no, :admission_date, :first_name,:last_name, :batch_id, :date_of_birth, :presence => true, :if => lambda { |o| o.current_step == "personal" }
  validates :admission_no, :uniqueness => true,:if => lambda { |o| o.current_step == "personal" }
  validates :gender, :presence => true,:if => lambda { |o| o.current_step == "personal" }
  validates_format_of     :email, :with => /^[A-Z0-9._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}$/i,   :allow_blank=>true,
    :message => "must be a valid email address", :if => lambda { |o| o.current_step == "address" }
  validates_format_of     :admission_no, :with => /^[A-Z0-9_-]*$/i,
    :message => "must contain only letters, numbers, hyphen, and  underscores",:if => lambda { |o| o.current_step == "image" }

  validates_associated :user
  before_validation :create_user_and_validate

  has_attached_file :student_photo,  :styles => { :small => "50x50#", :large => "500x500>"}, :processors => [:cropper]

  # validates_attachment_presence :student_photo,:if => lambda { |o| o.current_step == "image" }
  validates_attachment_size :student_photo, :less_than => 3.megabytes,:if => lambda { |o| o.current_step == "image" }
  validates_attachment_content_type :student_photo, :content_type => ['image/gif', 'image/png','image/jpeg', 'image/jpg'],:if => lambda { |o| o.current_step == "image" }

  # VALID_IMAGE_TYPES = ['image/gif', 'image/png','image/jpeg', 'image/jpg']
# # 
  # validates_attachment_content_type :student_photo, :content_type =>VALID_IMAGE_TYPES,
    # :message=>'Image can only be GIF, PNG, JPG',:if=> Proc.new { |p| !p.student_photo_file_name.blank? }
  # validates_attachment_size :student_photo, :less_than => 512000,\
    # :message=>'must be less than 500 KB.',:if=> Proc.new { |p| p.student_photo_file_name_changed? }

  validate :validate
  
  def validate
    
    errors.add(:date_of_birth, "can't be a future date.") if self.date_of_birth >= Date.today \
      unless self.date_of_birth.nil?
    errors.add(:gender, 'attribute is invalid.') unless ['m', 'f'].include? self.gender.downcase \
      unless self.gender.nil?
    errors.add(:admission_no, 'can\'t be zero') if self.admission_no=='0'
    
  end

  def create_user_and_validate
    self.email ||="#{self.first_name.gsub(/ /,'')}" + self.admission_no.to_s + "@ezzie.in"
    if self.new_record?
      user_record = self.build_user
      user_record.first_name = self.first_name
      user_record.last_name = self.last_name
      user_record.username = self.admission_no.to_s
      user_record.password = "password"
      user_record.role = 'Student'
      user_record.email = self.email.blank? ? "#{self.first_name}#{self.admission_no.to_s}@ezzie.in" : self.email.to_s
      check_user_errors(user_record)
      return false unless errors.blank?
    else
      self.user.role = "Student"
      changes_to_be_checked = ['admission_no','first_name','last_name','email']
      check_changes = self.changed & changes_to_be_checked
      unless check_changes.blank?
        self.user.username = self.admission_no if check_changes.include?('admission_no')
        self.user.first_name = self.first_name if check_changes.include?('first_name')
        self.user.last_name = self.last_name if check_changes.include?('last_name')
        self.user.email = self.email if check_changes.include?('email')
        check_user_errors(self.user)
      end
    end
    self.email = "#{self.first_name}#{self.admission_no}@ezzie.in" if self.email.blank?
    return false unless errors.blank?
  end

  def check_user_errors(user)
    unless user.valid?
      user.errors.each{|attr,msg| errors.add(attr.to_sym,"#{msg}")}
    end
    return false unless user.errors.blank?
  end

  def first_and_last_name
    "#{first_name} #{last_name}"
  end

  def full_name
    "#{first_name} #{middle_name} #{last_name}"
  end

  def gender_as_text
    return 'Male' if gender.downcase == 'm'
    return 'Female' if gender.downcase == 'f'
    nil
  end

  def all_batches
    # self.graduated_batches + self.batch.to_a
    #enoch - self.batch converted to array in a new format
    self.graduated_batches + [*self.batch]
  end

  def immediate_contact
    Guardian.find(self.immediate_contact_id) unless self.immediate_contact_id.nil?
  end

  # def image_file=(input_data)
    # return if input_data.blank?
    # self.photo_filename     = input_data.original_filename
    # self.photo_content_type = input_data.content_type.chomp
    # self.photo_data         = input_data.read
  # end

  def next_student
    next_st = self.batch.students.first(:conditions => "id > #{self.id}", :order => "id ASC")
    next_st ||= batch.students.first(:order => "id ASC")
  end

  def previous_student
    prev_st = self.batch.students.first(:conditions => "id < #{self.id}", :order => "admission_no DESC")
    prev_st ||= batch.students.first(:order => "id DESC")
    prev_st ||= self.batch.students.first(:order => "id DESC")
  end

  def previous_fee_student(date)
    fee = FinanceFee.first(:conditions => "student_id < #{self.id} and fee_collection_id = #{date}", :joins=>'INNER JOIN students ON finance_fees.student_id = students.id',:order => "student_id DESC")
    prev_st = fee.student unless fee.blank?
    fee ||= FinanceFee.first(:conditions=>"fee_collection_id = #{date}", :joins=>'INNER JOIN students ON finance_fees.student_id = students.id',:order => "student_id DESC")
    prev_st ||= fee.student unless fee.blank?
    #    prev_st ||= self.batch.students.first(:order => "id DESC")
  end

  def next_fee_student(date)

    fee = FinanceFee.first(:conditions => "student_id > #{self.id} and fee_collection_id = #{date}", :joins=>'INNER JOIN students ON finance_fees.student_id = students.id', :order => "student_id ASC")
    next_st = fee.student unless fee.nil?
    fee ||= FinanceFee.first(:conditions=>"fee_collection_id = #{date}", :joins=>'INNER JOIN students ON finance_fees.student_id = students.id',:order => "student_id ASC")
    next_st ||= fee.student unless fee.nil?
    #    prev_st ||= self.batch.students.first(:order => "id DESC")
  end

  def finance_fee_by_date(date)
    FinanceFee.find_by_fee_collection_id_and_student_id(date.id,self.id)
  end

  def check_fees_paid(date)
    particulars = date.fees_particulars(self)
    total_fees=0
    financefee = date.fee_transactions(self.id)
    batch_discounts = BatchFeeCollectionDiscount.find_all_by_finance_fee_collection_id(date.id)
    student_discounts = StudentFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(date.id,self.id)
    category_discounts = StudentCategoryFeeCollectionDiscount.find_all_by_finance_fee_collection_id_and_receiver_id(date.id,self.student_category_id)
    total_discount = 0
    total_discount += batch_discounts.map{|s| s.discount}.sum unless batch_discounts.nil?
    total_discount += student_discounts.map{|s| s.discount}.sum unless student_discounts.nil?
    total_discount += category_discounts.map{|s| s.discount}.sum unless category_discounts.nil?
    if total_discount > 100
      total_discount = 100
    end
    particulars.map { |s|  total_fees += s.amount.to_f}
    total_fees -= total_fees*(total_discount/100)
    paid_fees_transactions = FinanceTransaction.find(:all,:select=>'amount,fine_amount',:conditions=>"FIND_IN_SET(id,\"#{financefee.transaction_id}\")") unless financefee.nil?
    paid_fees = 0
    paid_fees_transactions.map { |m| paid_fees += (m.amount.to_f - m.fine_amount.to_f) } unless paid_fees_transactions.nil?
    amount_pending = total_fees.to_f - paid_fees.to_f
    if amount_pending == 0
      return true
    else
      return false
    end
  end
  
  def check_fee_pay(date)
    date.finance_fees.first(:conditions=>"student_id = #{self.id}").is_paid
  end

  def self.next_admission_no
    '' #stub for logic to be added later.
  end
  
  def get_fee_strucure_elements(date)
    elements = FinanceFeeStructureElement.get_student_fee_components(self,date)
    elements[:all] + elements[:by_batch] + elements[:by_category] + elements[:by_batch_and_category]
  end

  def total_fees(particulars)
    total = 0
    particulars.each do |fee|
      total += fee.amount
    end
    total
  end

  def archive_student(status)
    self.update_attributes(:is_active => false, :status_description => status)
    student_attributes = self.attributes
    student_attributes["former_id"]= self.id
    student_attributes.delete "id"
    student_attributes.delete "has_paid_fees"
    student_attributes.delete "student_photo_file_size"
    student_attributes.delete "student_photo_file_name"
    student_attributes.delete "student_photo_content_type"
    student_attributes.delete "is_transport_enabled"
    student_attributes.delete "user_id"
    archived_student = ArchivedStudent.new(student_attributes)
    archived_student.student_photo = self.student_photo
    require 'fileutils'
    FileUtils.rm_rf "#{RAILS_ROOT}/public/system/student_photos/" + self.id.to_s()
    if archived_student.save
        student_award = StudentAward.find_all_by_student_id(self.id)
        student_award.each do |sawd|
            @archived_student_award = ArchivedStudentAward.new(:title => sawd.title,:description => sawd.description,:award_date => sawd.award_date,:student_id => sawd.student_id,:batch_id => sawd.batch_id) unless sawd.nil?
            @archived_student_award.save unless sawd.nil?
            sawd.delete unless sawd.nil?
        end
      guardian = self.guardians
      self.user.delete unless self.user.blank?
      self.delete
      guardian.each do |g|
        g.archive_guardian(archived_student.id)
      end
      #
      student_exam_scores = ExamScore.find_all_by_student_id(self.id)
      student_exam_scores.each do |s|
        exam_score_attributes = s.attributes
        exam_score_attributes.delete "id"
        exam_score_attributes.delete "student_id"
        exam_score_attributes["student_id"]= archived_student.id
        ArchivedExamScore.create(exam_score_attributes)
        s.delete
      end
      student_additional_exam_scores = AdditionalExamScore.find_all_by_student_id(self.id)
      unless student_additional_exam_scores.nil?
        student_additional_exam_scores.each do |s|
          addtional_exam_score_attributes = s.attributes
          addtional_exam_score_attributes.delete "id"
          addtional_exam_score_attributes.delete "student_id"
          addtional_exam_score_attributes["student_id"]= archived_student.id
          ArchivedAdditionalExamScore.create(addtional_exam_score_attributes)
          s.delete
        end
      end
    end
 
  end
  
  def check_dependency
    flag = false
    flag = true unless self.finance_transactions.blank?
    flag = true unless self.graduated_batches.blank?
    flag = true unless self.attendances.blank?
    flag = true unless self.finance_fees.blank?
    if flag
      return true
    else
      return false
    end
  end

  def current_step
    @current_step || steps.first
  end

  def steps
    %w[personal address image image_crop parents] #partial names to be used in view
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
  
  def student_photo_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(student_photo.path(style))
  end
  
  def self.save(upload,current_user)
    begin
    collation = upload['datafilecol'].to_i
   # attachment_content_type = upload['datafile'].content_type
    attachment_student_id = upload['student_id']
    attachment_addmission = upload['addmision']
    Dir.mkdir("#{Rails.root}/public/system")unless Dir.exists?("#{Rails.root}/public/system")
    Dir.mkdir("#{Rails.root}/public/system/attachment")unless Dir.exists?("#{Rails.root}/public/system/attachment")
    Dir.mkdir("#{Rails.root}/public/system/attachment/student")unless Dir.exists?("#{Rails.root}/public/system/attachment/student")
    Dir.mkdir("#{Rails.root}/public/system/attachment/student/#{attachment_student_id}")unless Dir.exists?("#{Rails.root}/public/system/attachment/student/#{attachment_student_id}")
    Dir.mkdir("#{Rails.root}/public/system/attachment/student/#{attachment_student_id}/#{upload[:value]}")unless Dir.exists?("#{Rails.root}/public/system/attachment/student/#{attachment_student_id}/#{upload[:value]}")
    directory = "#{Rails.root}/public/system/attachment/student/#{attachment_student_id}/#{upload[:value]}"
    index = 1
    collation.times do |i|
       name = 'datafile'+ index.to_s
       puts name
       attachment_filename = upload[name].original_filename
       unless File.exists?("#{Rails.root}/public/system/attachment/student/#{attachment_student_id}/#{upload[:value]}/#{attachment_filename}")
          Attachment.create!(:dir_name => "#{upload[:value]}",:student_id => attachment_student_id ,:file_name => attachment_filename,:created_by_id => current_user.id)
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
  
  def reprocess_student_photo
    student_photo.reprocess!
  end


end
