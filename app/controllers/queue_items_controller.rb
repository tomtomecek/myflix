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

end