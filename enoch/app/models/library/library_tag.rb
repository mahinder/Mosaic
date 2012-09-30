class LibraryTag < ActiveRecord::Base
validates :name,:presence => true 
  validates :name , :length =>{:maximum => 25}
  has_many :library_books
  validates  :name, :uniqueness => true 
end
