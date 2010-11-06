class Dashboard::StatsController < Dashboard::DashboardController
  before_filter :check_link
  
  protected
  def check_link
    unless current_user.linked_to_twitter?
      redirect_to [:dashboard, :profile], :notice => "Veuillez lier votre compte aux réseaux sociaux..."
    end
  end
  
  public
  def popular_followers
    @stat = current_user.stats_popular_followers.last
  end
end
