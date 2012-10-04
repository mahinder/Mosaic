class CreateEmployeesSkillsJoin < ActiveRecord::Migration
  def up
     create_table :employees_skills, :id => false do |t|
      t.column "employee_id", :integer
      t.column "skill_id", :integer
  end

  def down
    drop_table :employees_skills
  end
  end
end
