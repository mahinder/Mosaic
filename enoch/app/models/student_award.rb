class StudentAward < ActiveRecord::Base
  belongs_to :batch
  belongs_to :student
  validates :title,:description,:award_date, :presence => true
end
