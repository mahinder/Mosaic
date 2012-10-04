# == Schema Information
#
# Table name: finance_transaction_categories
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  is_income   :boolean
#  deleted     :boolean         default(FALSE), not null
#

#Fedena
#Copyright 2011 Foradian Technologies Private Limited
#
#This product includes software developed at
#Project Fedena - http://www.projectfedena.org/
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

class FinanceTransactionCategory < ActiveRecord::Base
  has_many :finance_transactions
  has_one  :trigger, :class_name => "FinanceTransactionTrigger", :foreign_key => "category_id"

  # validates :name
  #enoch - presence_of syntax changed    
  validates :name, :presence => true
  validates :name, :uniqueness => true

  scope :expense_categories, :conditions => "is_income = 'f' AND name NOT LIKE 'Salary'and deleted = 'f'"
  scope :income_categories, :conditions => "is_income = 't' AND name NOT IN ('Fee','Salary','Donation','Library','Hostel','Transport') and deleted = 'f'"

#  def self.expense_categories
#    FinanceTransactionCategory.all(:conditions => "is_income = false AND name NOT LIKE 'Salary'")
#  end
#
#  def self.income_categories
#    FinanceTransactionCategory.all(:conditions => "is_income = true AND name NOT LIKE 'Fee' AND name NOT LIKE 'Donation'")
#  end

end
