
class FinanceFeeCategory < ActiveRecord::Base
  has_and_belongs_to_many :batches
  # belongs_to :batch
  belongs_to :student
  has_many   :fee_particulars, :class_name => "FinanceFeeParticulars"
  has_many   :fee_collections, :class_name => "FinanceFeeCollection"
  has_many   :fee_discounts
  
  cattr_reader :per_page

  @@per_page = 10
  # validates :name
  #enoch - presence_of syntax changed  
  validates :name,:presence => true
  # validates :batch_id,:message=>" not specified"  
  #enoch - presence_of syntax changed  
  # validates :batch_id,:presence => true 
  
  validates_uniqueness_of :name, :scope=>[:school_session_id, :is_deleted],:if=> 'is_deleted == false'

  def fees(student)
    FinanceFeeParticulars.find_all_by_finance_fee_category_id(self.id,
      :conditions => ["((student_category_id IS NULL AND admission_no IS NULL )OR(student_category_id = '#{student.student_category_id}'AND admission_no IS NULL) OR (student_category_id IS NULL AND admission_no = '#{student.admission_no}')) and is_deleted=0"])
  end

  def check_fee_collection
    fee_collection = FinanceFeeCollection.find_all_by_fee_category_id(self.id)
    fee_collection.empty? ? true : false
  end

  def check_fee_collection_for_additional_fees
    flag =0
    fee_collection = FinanceFeeCollection.find_all_by_fee_category_id(self.id)
    fee_collection.each do |fee|
      flag = 1 if fee.check_fee_category == true
    end
    flag == 1 ?  true : false
    
  end
 
  def has_published_collection_date(finance_fee_category)
    amount_taken = FinanceFeeCollection.find_all_by_fee_category_id(finance_fee_category.id,:conditions => {:is_deleted => false})
    if amount_taken.count == 0
      return false
    else
      return true
    end
  end

  def delete_particulars
    self.fee_particulars.each do |fees|
      fees.update_attributes(:is_deleted => true)
    end
  end

  def student_fee_balance(student,date)
    particulars= FinanceFeeParticulars.find_all_by_finance_fee_category_id(self.id,
      :conditions => ["((student_category_id IS NULL AND admission_no IS NULL )OR(student_category_id = '#{student.student_category_id}'AND admission_no IS NULL) OR (student_category_id IS NULL AND admission_no = '#{student.admission_no}')) and is_deleted=0"])
    financefee = student.finance_fee_by_date(date)

    paid_fees = FinanceTransaction.find(:all,:conditions=>"FIND_IN_SET(id,\"#{financefee.transaction_id}\")") unless financefee.transaction_id.blank?

    batch_discounts = BatchFeeDiscount.find_all_by_finance_fee_category_id(self.id)
    student_discounts = StudentFeeDiscount.find_all_by_finance_fee_category_id_and_receiver_id(self.id,student.id)
    category_discounts = StudentCategoryFeeDiscount.find_all_by_finance_fee_category_id(self.id, :joins=>'INNER JOIN students ON fee_discounts.receiver_id = students.student_category_id')
    total_discount = 0
    total_discount += batch_discounts.map{|s| s.discount}.sum unless batch_discounts.nil?
    total_discount += student_discounts.map{|s| s.discount}.sum unless student_discounts.nil?
    total_discount += category_discounts.map{|s| s.discount}.sum unless category_discounts.nil?
    if total_discount > 100
      total_discount = 100
    end

    total_fees =0
    unless particulars.nil?
      total_fees += particulars.collect{|x|x.amount.to_f}.sum
      total_fees = (total_fees - ((total_fees*total_discount)/100))
      
      unless paid_fees.nil?
        paid = 0
        paid += paid_fees.collect{|x|x.amount.to_f}.sum
        total_fees -= paid
        trans = FinanceTransaction.find(financefee.transaction_id)
        unless trans.nil?
        total_fees += trans.fine_amount.to_f if trans.fine_included
        end
      end
    end
    return total_fees
  end


  def is_collection_open
    collection = FinanceFeeCollection.find_all_by_fee_category_id(self.id,:conditions=>"start_date < '#{Date.today.to_date}' and due_date > '#{Date.today.to_date}'")
    collection.reject!{ |c|c.no_transaction_present } unless collection.nil?
    collection.present?
  end
  
  
end
