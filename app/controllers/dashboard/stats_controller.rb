class Dashboard::StatsController < Dashboard::DashboardController
  before_filter :check_link
  
  protected
  def check_link
    unless current_user.linked_to_twitter?
      redirect_to [:dashboard, :profile], :notice => "Veuillez lier votre compte aux réseaux sociaux..."
    end
  end
  
  public
  def update_twitter_user
    Resque.enqueue(TwitterUserJob, current_user.id, current_user.twitter_main_id, true)
    
    redirect_to dashboard_root_path, :notice => "Nous avons demandé à notre cochon d'Inde de préparer une mise à jour ! Rafraichissez la page dans quelques temps..."
  end
  
  def popular_followers
    @stat = current_user.stats_twitter_popular_followers.last
  end
  
  def followers_count
    @stat = current_user.stats_twitter_follower_counts.all
  end
end
