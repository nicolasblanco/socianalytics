class TwitterBlockJob
  extend Resque::Plugins::Restriction
  
  @queue = :medium
  restrict :per_hour => 50, :concurrent => 1
  
  def self.restriction_identifier(user_id, twitter_id)
    [self.to_s, user_id.to_s].join(":")
  end
  
  def self.perform(user_id, twitter_id)
    user = User.find(user_id)
    user.twitter_client.block(twitter_id.to_i)
  end
end
