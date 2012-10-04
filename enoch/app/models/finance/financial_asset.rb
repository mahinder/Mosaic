class FinancialAsset < ActiveRecord::Base
  validates :title, :presence => true, :uniqueness => true
  validates :amount, :presence => true, :numericality => true
end
