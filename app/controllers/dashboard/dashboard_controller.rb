class Dashboard::DashboardController < LoggedController
  layout 'dashboard'
  before_filter :check_rights!
  helper_method :current_twitter_user
  
  protected
  def check_rights!
    redirect_to '/' unless current_user.admin? || current_user.authorized?
  end
  
  def current_twitter_user
    @current_twitter_user ||= current_user.twitter_user
  end

  def require_twitter_user!
    redirect_to(dashboard_root_path, :notice => "Please wait some seconds, we need to update your account...") unless current_twitter_user
  end
end
