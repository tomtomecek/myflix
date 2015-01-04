class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.string :customer_id
      t.string :subscription_id
      t.timestamps
    end
  end
end