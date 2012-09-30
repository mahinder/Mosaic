class Provider < ActiveRecord::Base
  validates :name,:address,:city,:mobile, :presence=>true
  validates :name,:uniqueness=>true
end
