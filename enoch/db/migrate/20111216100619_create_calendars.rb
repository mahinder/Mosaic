class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|

      t.timestamps
    end
  end
end
