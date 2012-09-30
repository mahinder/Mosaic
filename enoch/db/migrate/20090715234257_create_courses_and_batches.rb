class CreateCoursesAndBatches < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string     :course_name
      t.string     :code
      t.string     :section_name
      t.boolean    :is_deleted, :default => false
      t.integer    :level
      t.timestamps
    end

    create_table :batches do |t|
      t.string     :name
      t.references :course
      t.references :school_session
      t.references :room
      t.references :class_teacher
      t.datetime   :start_date
      t.datetime   :end_date
      t.boolean    :is_active, :default => true
      t.boolean    :is_deleted, :default => false
      t.boolean    :is_timetable_created, :default => false
    end
  end

  def self.down
    drop_table :batches
    drop_table :courses
  end

end
