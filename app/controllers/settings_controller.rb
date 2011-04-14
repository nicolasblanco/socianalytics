# encoding: utf-8
class SettingsController < LoggedController
  def facebook_session
    access_token_hash = MiniFB.oauth_access_token(FacebookConfig.application_id, facebook_session_settings_url, FacebookConfig.application_secret, params[:code])
    current_user.facebook_access_token = access_token_hash["access_token"]
    current_user.save
    
    redirect_to settings_path, :notice => "Facebook account successfully linked!"
  end
  
  def update
    current_user.update_attributes(params[:user])
    
    redirect_to settings_path, :notice => "User successfully updated!"
  end
end
