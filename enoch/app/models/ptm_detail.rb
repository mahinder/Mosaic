class PtmDetail < ActiveRecord::Base
  belongs_to :employee
  belongs_to :ptm_master
  belongs_to :student
end
