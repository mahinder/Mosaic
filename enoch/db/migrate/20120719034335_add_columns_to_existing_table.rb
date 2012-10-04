class AddColumnsToExistingTable < ActiveRecord::Migration
  def self.up
    add_column :finance_fees, :is_paid, :boolean, :default => 0
    add_column :students, :is_transport_enabled, :boolean, :default => 0
    add_column :events, :origin_id,  :integer
    add_column :events, :origin_type,  :string
  end

  def self.down
    remove_column :finance_fees, :is_paid
    remove_column :students, :is_transport_enabled
    remove_column :events, :origin_id,  :integer
    remove_column :events, :origin_type,  :string
  end
end
