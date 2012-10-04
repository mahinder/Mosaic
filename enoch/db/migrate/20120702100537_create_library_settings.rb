class CreateLibrarySettings < ActiveRecord::Migration
  def change
    create_table :library_settings do |t|
      t.integer :default_no_of_days_for_issue
      t.integer :renew_period
      t.string :category 
      t.integer :no_of_books_to_be_issued
      t.integer :fine_charged_per_day_after_due_date
      t.timestamps
      
    end
  end
end
