class Topic < ActiveRecord::Base
  belongs_to :subject
  validates_uniqueness_of :name, :scope => :subject_id
  validates :name , :length =>{:maximum => 50}
  has_many :exams
  has_many :additional_exams
end
