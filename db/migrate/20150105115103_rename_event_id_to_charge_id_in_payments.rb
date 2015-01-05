class RenameEventIdToChargeIdInPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :event_id, :charge_id
    remove_column :payments, :amount
    add_column :payments, :amount, :integer
  end
end
