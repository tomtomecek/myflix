class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.string :event_id
      t.integer :amount, default: 999
      t.timestamps
    end
  end
end
