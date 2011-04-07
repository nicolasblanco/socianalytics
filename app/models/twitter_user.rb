class TwitterUser
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps
  
  @@twitter_fields = %w(location profile_image_url screen_name friends_count followers_count)
  cattr_reader :twitter_fields
  
  @@twitter_latest_tweet_fields = %w(created_at text)
  cattr_reader :twitter_latest_tweet_fields
  
  field :twitter_id
  field :followers_ids,  :type => Array, :default => []
  field :followings_ids, :type => Array, :default => []
  @@twitter_fields.each { |f| field :"twitter_#{f}" }
  @@twitter_latest_tweet_fields.each { |f| field :"twitter_latest_tweet_#{f}" }

  index :twitter_followers_count
  
  def raw=(twitter_response)
    twitter_fields.each { |tf| send("twitter_#{tf}=", twitter_response.send(tf)) if twitter_response.include?(tf) }
    twitter_latest_tweet_fields.each { |tf| send("twitter_latest_tweet_#{tf}=", twitter_response.status.send(tf)) if twitter_response.status && twitter_response.status.include?(tf) }
    self.twitter_latest_tweet_created_at = (twitter_latest_tweet_created_at.try(:to_time) rescue nil)
  end
  
  def friends_ids
    followers_ids & followings_ids
  end

  def no_following_followers_ids
    followings_ids - followers_ids
  end
  
  def friends_size
    friends_ids.size
  end
  
  def async_update!(user)
    Resque.enqueue(TwitterUserJob, user.id, twitter_id)
  end
  
  def stat_mash(attribute)
    Hashie::Mash.new(:updated_at => updated_at, :value => send(attribute))
  end
  
  def stat_for(attribute)
    versions.map { |v| v.stat_mash(attribute) }.push(stat_mash(attribute))
  end
end
