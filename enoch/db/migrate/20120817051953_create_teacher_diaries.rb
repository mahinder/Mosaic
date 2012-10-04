class CreateTeacherDiaries < ActiveRecord::Migration
  def change
    create_table :teacher_diaries do |t|
      t.references :employee
      t.references :school_session
      t.string     :timing
      t.string     :description, :limit => 5000
      t.date       :text_date
      t.timestamps
    end
  end
end
