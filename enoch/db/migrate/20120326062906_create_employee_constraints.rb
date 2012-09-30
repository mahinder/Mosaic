class CreateEmployeeConstraints < ActiveRecord::Migration
  def change
    create_table :employee_constraints do |t|
       t.references :employee
      t.references :class_timing
      t.references :weekday
      t.timestamps
    end
  end
end
