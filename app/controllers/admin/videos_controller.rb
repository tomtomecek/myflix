class Admin::VideosController < AdminsController
  
  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    
    if @video.save
      flash[:success] = "xxx"
      redirect_to home_url
    else
      render :new
    end
  end

private

  def video_params
    params.require(:video).permit!
  end

end