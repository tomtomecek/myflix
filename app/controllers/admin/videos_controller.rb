class Admin::VideosController < AdminsController
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    if @video.save
      flash[:success] = "You have succesfully added new video."
      redirect_to new_admin_video_url
    else
      render :new
    end
  end

private

  def video_params
    params.require(:video).permit(:title,
                                  :description,
                                  :category_id,
                                  :video_url,
                                  :large_cover,
                                  :small_cover)
  end
end
