class AdminsController < AuthenticatedController
  before_action :require_admin

  def require_admin
    unless current_user.admin?
      flash[:danger] = "Restricted area."
      redirect_to home_url
    end
  end
end
