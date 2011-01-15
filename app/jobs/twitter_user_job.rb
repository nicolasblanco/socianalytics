#require 'resque/plugins/lock'

class TwitterUserJob
  extend Resque::Plugins::Restriction
  
  @queue = :normal
  restrict :per_hour => 200, :concurrent => 1
  
  def self.restriction_identifier(user_id, twitter_id)
    [self.to_s, twitter_id].join(":")
  end
  
  def self.perform(user_id, twitter_id)
    user = User.find(user_id)
    twitter_user = TwitterUser.find_or_initialize_by(:twitter_id => twitter_id)
    
    twitter_user.raw = user.twitter_client.user(:user_id => twitter_id)
    twitter_user.followers_ids  = user.twitter_client.follower_ids(:user_id => twitter_id).ids
    twitter_user.followings_ids = user.twitter_client.friend_ids(:user_id => twitter_id).ids
    twitter_user.save
  end
end
