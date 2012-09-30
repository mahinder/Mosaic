class LibrarySetting < ActiveRecord::Base

validates  :category, :uniqueness => true 


end
