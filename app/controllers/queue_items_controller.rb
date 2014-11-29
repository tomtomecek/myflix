class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_video(video)
    redirect_to my_queue_url
  end

  def destroy
    queue_item = QueueItem.find(params[:id])
    queue_item.destroy if current_user.owns?(queue_item)
    current_user.normalizes_queue_items
    redirect_to my_queue_url
  end

  def update_queue
    if params[:queue_items]
      update_ratings
      begin
        update_positions      
        current_user.normalizes_queue_items      
      rescue ActiveRecord::RecordInvalid
        flash[:danger] = "Invalid position number."
      end
    end
    redirect_to my_queue_url
  end

  private

    def queue_video(video)
      QueueItem.create(video: video, user: current_user, position: new_queued_position) unless is_video_queued?(video)
    end

    def new_queued_position
      current_user.queue_items.count + 1
    end

    def is_video_queued?(video)
      current_user.queue_items.map(&:video).include?(video)
    end

    def update_positions
      ActiveRecord::Base.transaction do
        params[:queue_items].each do |updated_queue_item|
          queue_item = QueueItem.find(updated_queue_item[:id])          
          queue_item.update!(position: updated_queue_item[:position]) if queue_item.user == current_user
        end
      end
    end

    def update_ratings
      params[:queue_items].each do |updated_qi|
        unless updated_qi[:review_id].blank?
          review = Review.find(updated_qi[:review_id])
          review.update(rating: updated_qi[:rating])
        else
          unless updated_qi[:rating].blank?
            review = Review.new(rating: updated_qi[:rating], video_id: updated_qi[:video_id], user: current_user)
            review.save(validate: false)
          end
        end
      end
    end


end