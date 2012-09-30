class CoScholasticActivity < ActiveRecord::Base
  has_and_belongs_to_many :courses
  has_many :co_scholastic_sub_skill_activities, :dependent => :destroy
  validates :co_scholastic_activity_name ,:presence => true
  
  def validate_uniqueness_of_name(params)
    self_check= self.new_record? ? "" : "id != #{self.id}"
    @error = false
    co_scholastic_activities = CoScholasticActivity.find(:all, :conditions=>[self_check])
    co_scholastic_activities.each do |activity|
      if activity.co_scholastic_activity_name == self.co_scholastic_activity_name
        params[:course_list].each do |id|
          course = Course.find_by_id(id)
          if activity.courses.include?(course) == true
            @error = true
          end
        end
      end
    end
    return @error
  end
end
