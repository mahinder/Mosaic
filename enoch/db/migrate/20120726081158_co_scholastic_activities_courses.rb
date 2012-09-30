class CoScholasticActivitiesCourses < ActiveRecord::Migration
  def up
     create_table :co_scholastic_activities_courses do |t|
      t.references :course
      t.references :co_scholastic_activity
      t.timestamps
    end
  end

  def down
    drop_table :co_scholastic_activities_courses
  end
end
