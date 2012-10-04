class CreateSmsTemplates < ActiveRecord::Migration
  def change
    create_table :sms_templates do |t|
      t.string :template_code
      t.string :text
      t.boolean :is_inactive,:default=>false      
      t.timestamps
    end
  end
end
