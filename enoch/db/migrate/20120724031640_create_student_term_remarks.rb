class CreateStudentTermRemarks < ActiveRecord::Migration
  def change
    create_table :student_term_remarks do |t|
      t.references :term_master
      t.references :student
      t.references :batch
      t.references :school_session
      t.string     :remarks
      t.string     :remarks_type, :default => "None"
      t.timestamps
    end
    
  end
  
end
