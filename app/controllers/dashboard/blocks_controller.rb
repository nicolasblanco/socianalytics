class Dashboard::BlocksController < Dashboard::DashboardController
  def batch_create
    if params[:twitter_ids].present?
      params[:twitter_ids].each do |twitter_id|
        Resque.enqueue(TwitterBlockJob, current_user.id, twitter_id)
      end
    end
    
    redirect_to spam_followers_dashboard_stats_path, :notice => "Les profils que vous avez sélectionnés seront bloqués de votre compte dans les prochaines heures. Merci."
  end
end
