class Payment < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :amount, :user_id, :charge_id
end