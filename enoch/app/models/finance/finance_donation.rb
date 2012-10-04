# == Schema Information
#
# Table name: finance_donations
#
#  id               :integer         not null, primary key
#  donor            :string(255)
#  description      :string(255)
#  amount           :decimal(, )
#  transaction_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#  transaction_date :date
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

class FinanceDonation < ActiveRecord::Base
  belongs_to :transaction, :class_name => 'FinanceTransaction',  :dependent => :destroy
  validates :donor, :amount , :presence => true
  # validates_numericality_of :amount, :greater_than_or_equal_to => 0, :message => 'must be positive'
  #enoch - presence_of syntax changed
  validates :amount, :numericality =>{ :greater_than_or_equal_to => 0, :message => 'must be positive' }

  before_create :create_finance_transaction
 
  def self.donation(start_date,end_date)
    expenses = FinanceDonation.find(:all,:conditions => ["transaction_date >= '#{start_date}' and transaction_date <= '#{end_date}'"])
    expenses
  end
 
  def create_finance_transaction
    transaction = FinanceTransaction.create!(
    :title => "Donation from " + donor,
    :description => description,
    :amount => amount,
    :transaction_date => transaction_date,
    :category => FinanceTransactionCategory.find_by_name('Donation')
    )
    self.transaction_id = transaction.id
  end
end
