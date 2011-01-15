class Dashboard::ProfilesController < Dashboard::DashboardController
  before_filter :load_twitter_oauth, :only => %w(twitter_link twitter_callback)
  
  protected
  def load_twitter_oauth
    @twitter_consumer = OAuth::Consumer.new(Twitter.consumer_key, Twitter.consumer_secret, { :site => "http://api.twitter.com", :request_endpoint => "http://api.twitter.com" })
  end
  
  public
  def facebook_link
    
  end
  
  def twitter_link
    @twitter_request_token = @twitter_consumer.get_request_token(:oauth_callback => twitter_callback_dashboard_profile_url)
    session[:twitter_request_token], session[:twitter_request_secret] = @twitter_request_token.token, @twitter_request_token.secret
    
    redirect_to @twitter_request_token.authorize_url
  end
  
  def twitter_callback
    @twitter_access_token = OAuth::RequestToken.new(@twitter_consumer, session[:twitter_request_token], session[:twitter_request_secret]).get_access_token(:oauth_verifier => params[:oauth_verifier])
    current_user.twitter_oauth_token, current_user.twitter_oauth_secret = @twitter_access_token.token, @twitter_access_token.secret
    current_user.twitter_main_id = current_user.twitter_client.user.id
    current_user.save
    
    redirect_to [:dashboard, :profile], :notice => "Lien vers compte Twitter créé avec succès !"
  end
  
  def destroy_twitter_link
    current_user.twitter_oauth_token = current_user.twitter_oauth_secret = nil
    current_user.save
    
    redirect_to [:dashboard, :profile], :notice => "Lien vers compte Twitter supprimé avec succès !"
  end
  
  def facebook_callback
    
  end
end
