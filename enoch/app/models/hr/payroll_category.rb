class PayrollCategory < ActiveRecord::Base
  validates :name, :uniqueness => true
  validates :name, :presence => true
  validates :name , :length =>{:maximum => 25}
  has_many :monthly_paslips

end
