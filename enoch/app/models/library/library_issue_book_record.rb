class LibraryIssueBookRecord < ActiveRecord::Base
  
 belongs_to :batch
 belongs_to :library_book
 belongs_to :user 
end
