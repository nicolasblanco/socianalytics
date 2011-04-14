# encoding: utf-8
class Dashboard::StatsController < Dashboard::DashboardController
  before_filter :check_link
  before_filter :require_twitter_user!, :except => %w(update_twitter_user)

  protected
  def check_link
    unless current_user.linked_to_twitter?
      redirect_to [:dashboard, :profile], :notice => "Veuillez lier votre compte aux réseaux sociaux..."
    end
  end
  
  public
  def basic
    
  end
  
  def update_twitter_user
    Resque.enqueue(TwitterUserJob, current_user.id, current_user.twitter_main_id, true)
    
    redirect_to dashboard_root_path, :notice => "Nous avons demandé à notre cochon d'Inde de préparer une mise à jour ! Rafraichissez la page dans quelques temps..."
  end
  
  def popular_followers
    @followers = TwitterUser.any_in(:twitter_id => current_twitter_user.followers_ids).desc(:twitter_followers_count).paginate(:page => params[:page], :per_page => 20)
  end

  def friends
    @followers = TwitterUser.any_in(:twitter_id => current_twitter_user.friends_ids).desc(:twitter_followers_count).paginate(:page => params[:page], :per_page => 20)
  end

  def no_following_followers
    @followers = TwitterUser.any_in(:twitter_id => current_twitter_user.no_following_followers_ids).desc(:twitter_followers_count).paginate(:page => params[:page], :per_page => 20)
  end

  def spam_followers
    @followers = TwitterUser.any_in(:twitter_id => current_twitter_user.followers_ids).where(:twitter_followers_count.lt => 50, :twitter_friends_count.gt => 100).paginate(:page => params[:page], :per_page => 20)
  end
end
