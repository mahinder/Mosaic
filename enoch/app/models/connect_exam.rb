class ConnectExam < ActiveRecord::Base
  belongs_to :grouped_exam
  validate :validate
  def validate
   
  
  end
end
