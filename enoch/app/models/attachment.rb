class Attachment < ActiveRecord::Base
belongs_to :student
belongs_to :created_by ,:class_name => 'User'
belongs_to :deleted_by ,:class_name => 'User'
end
