# == Schema Information
#
# Table name: student_previous_data
#
#  id          :integer         not null, primary key
#  student_id  :integer
#  institution :string(255)
#  year        :string(255)
#  course      :string(255)
#  total_mark  :string(255)
#



class StudentPreviousData < ActiveRecord::Base
  belongs_to :student
  validates :institution,:presence => true
end
