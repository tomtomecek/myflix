class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id, :video_id, :rating
      t.text :body

      t.timestamps
    end
  end
end
