class TwitterUserLookup  
  @queue = :medium

  def self.perform(user_id, twitter_ids)
    user = User.find(user_id)
    twitter_users_raw = user.twitter_client.users(twitter_ids)
    
    twitter_users_raw.each do |twitter_user_raw|
      twitter_user = TwitterUser.find_or_initialize_by(:twitter_id => twitter_user_raw.id)
      twitter_user.raw = twitter_user_raw
      
      twitter_user.set_updated_at # So that we're sure that a new version will be created even if the record is unchanged.
      twitter_user.save
    end
  end
end
