class LibraryBook < ActiveRecord::Base
  validates :name,:presence => true 
  validates :name , :length =>{:maximum => 25}
  validates  :name, :uniqueness => true 
  belongs_to :library_author
  belongs_to :library_tag
  has_many   :library_issue_book_records
  
end
