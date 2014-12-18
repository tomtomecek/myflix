class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :sender_id
      t.string :recipient_name
      t.string :recipient_email
      t.text :message
      t.string :token
      t.timestamps
    end
  end
end
