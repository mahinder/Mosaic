class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photos , :dependent => :destroy
  validates :name, presence: true, uniqueness: true
  attr_accessible :name, :user_id, :photos_attributes
  accepts_nested_attributes_for :photos,:reject_if => lambda { |a| a[:album_photo].blank? }, :allow_destroy => true
end
