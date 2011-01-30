class Dashboard::DashboardController < LoggedController
  layout 'dashboard'
  before_filter :check_rights
  helper_method :current_twitter_user
  
  protected
  def check_rights
    redirect_to '/' unless current_user.admin?
  end
  
  def current_twitter_user
    @current_twitter_user ||= current_user.twitter_user
  end
end
