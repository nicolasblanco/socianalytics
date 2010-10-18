class Dashboard::DashboardController < LoggedController
  layout 'dashboard'
  before_filter :check_rights
  
  protected
  def check_rights
    redirect_to '/' unless current_user.admin?
  end
end
