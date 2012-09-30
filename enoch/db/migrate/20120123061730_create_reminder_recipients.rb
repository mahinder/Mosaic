class CreateReminderRecipients < ActiveRecord::Migration
  def change
    create_table :reminder_recipients do |t|
      t.references :reminder
      t.integer  :recipient
      t.boolean  :is_read, :default=>false
      t.boolean  :is_deleted_by_recipient, :default=>false
      t.timestamps
    end
  end
end
