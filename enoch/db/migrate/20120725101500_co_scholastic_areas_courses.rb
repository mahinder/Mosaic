class CoScholasticAreasCourses < ActiveRecord::Migration
  def up
     create_table :co_scholastic_areas_courses do |t|
      t.references :course
      t.references :co_scholastic_area
      t.timestamps
    end
  end

  def down
     drop_table :co_scholastic_areas_courses
  end
end
