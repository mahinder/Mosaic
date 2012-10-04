# == Schema Information
#
# Table name: assets
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  amount      :integer
#  is_inactive :boolean         default(FALSE)
#  is_deleted  :boolean         default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'


describe FinancialAsset do
  before(:each) do
    @asset_attr = {
      :title => "electronics",
      :amount => 2000,
      :description => "assets description",
      :is_inactive => true,
      :is_deleted => false
    }
  end
  describe "validates" do
    it "should check the exist of asset" do
      asset = FinancialAsset.new(@asset_attr)
      asset.should be_valid
    end
    it "should respond to title and amount and others attributes" do
      asset = FinancialAsset.new(@asset_attr)
      asset.should respond_to(:title)
      asset.should respond_to(:amount)
      asset.should respond_to(:description)
      asset.should respond_to(:is_inactive)
      asset.should respond_to(:is_deleted)
    end
    it "title and amount should be present" do
      asset = FinancialAsset.new(@asset_attr.merge(:title => ""))
      asset.should_not be_valid
    end
    it "amount should be present" do
      asset = FinancialAsset.new(@asset_attr.merge(:amount => ""))
      asset.should_not be_valid
    end
    it "amount should be numeric" do
      asset = FinancialAsset.new(@asset_attr.merge(:amount => "invalid"))
      asset.should_not be_valid
    end
  end
end
