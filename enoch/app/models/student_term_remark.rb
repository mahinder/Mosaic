class StudentTermRemark < ActiveRecord::Base
  belongs_to :batch
  belongs_to :student
  belongs_to :school_session
  belongs_to :term_master
  validates :term_master_id, :uniqueness => {:scope => [:batch_id,:school_session_id,:student_id,:remarks_type]} 
  validates :term_master,:batch ,:presence => true
  
end
