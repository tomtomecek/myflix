class Admin::VideosController < AdminsController
  
  def new
    @video = Video.new
  end
  
end