class CreateLibraryIssueBookRecords < ActiveRecord::Migration
  def change
    create_table :library_issue_book_records do |t|
      t.references :library_book
      t.references :user
      t.references :batch
      t.boolean :is_return, :default => false
      t.date :issue_date
      t.date :due_date
      t.date :actual_return_date
      t.integer :total_fine
      t.integer :actual_fine_paid
       t.boolean :is_fine_paid, :default => false
      t.timestamps
    end
  end
end
