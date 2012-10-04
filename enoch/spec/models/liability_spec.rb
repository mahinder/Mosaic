# == Schema Information
#
# Table name: liabilities
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  amount      :integer
#  is_solved   :boolean         default(FALSE)
#  is_deleted  :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'



describe Liability do
  before(:each) do
    @liability_attr = {
      :title => "electronics",
      :amount => 2000,
      :description => "liabilitys description",
      :is_solved => true,
      :is_deleted => false
    }
  end
  describe "validates" do
    it "should check the exist of liability" do
      liability = Liability.new(@liability_attr)
      liability.should be_valid
    end
    it "should respond to title and amount and others attributes" do
      liability = Liability.new(@liability_attr)
      liability.should respond_to(:title)
      liability.should respond_to(:amount)
      liability.should respond_to(:description)
      liability.should respond_to(:is_solved)
      liability.should respond_to(:is_deleted)
    end
    it "title should be present" do
      liability = Liability.new(@liability_attr.merge(:title => ""))
      liability.should_not be_valid
    end
    it "amount should be present" do
      liability = Liability.new(@liability_attr.merge(:amount => ""))
      liability.should_not be_valid
    end
    it "amount should be numeric" do
      liability = Liability.new(@liability_attr.merge(:amount => "invalid"))
      liability.should_not be_valid
    end
  end
end
