class Skill < ActiveRecord::Base
  belongs_to :course
  has_many :sub_skills
  belongs_to :elective_skill
  validates :name, :max_weekly_classes, :code, :presence => true
  validates_numericality_of :max_weekly_classes
  validates_uniqueness_of :code, :scope => :course_id
  scope :active,{ :conditions => { :is_active => true }}
  has_and_belongs_to_many :employees
  def inactivate
    update_attribute(:is_active, false)
  end

  def course_batch(course)
      @name = ''
      @id= ''
      @all = []
      
      @batch = course.batches.active 
    
     unless @batch.empty?
       @batch.each do |batch|
         if @name == '' and @id == ''
              @name = @name + batch.full_name
              @id = @id + batch.id.to_s
            else
               @name = @name + ','+batch.full_name
               @id = @id +','+batch.id.to_s
         end
       end
     @all[0] = @name
     @all[1] = @id
     end 
    
    return @all
end
end