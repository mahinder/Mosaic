class LibraryAuthor < ActiveRecord::Base
  validates :name,  :presence => true
  validates :name , :length =>{:maximum => 50}
  has_many  :library_books
  validates  :name, :uniqueness => true 
end
