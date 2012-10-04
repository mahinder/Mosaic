class CreatePtmMasters < ActiveRecord::Migration
  def change
    create_table :ptm_masters do |t|
      t.string     :title
      t.string     :description
      t.references :batch
      t.references :event
      t.date       :ptm_start_date
      t.date       :ptm_end_date
      t.boolean    :is_active, :default => true
      t.timestamps
    end
  end
end
