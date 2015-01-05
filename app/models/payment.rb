class Payment < ActiveRecord::Base
  belongs_to :user

  def call(event)
    self.id     = event.id
    self.amount = event.data.object.amount
    save
  end

end