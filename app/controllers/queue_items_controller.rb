class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    QueueItem.create(video_id: params[:video_id], user: current_user)
    redirect_to my_queue_url
  end

end