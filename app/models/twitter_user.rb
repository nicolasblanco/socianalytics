class TwitterUser
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps
  
  @@twitter_fields = %w(location profile_image_url screen_name friends_count followers_count)
  cattr_reader :twitter_fields
  
  field :twitter_status_created_at, :type => DateTime
  field :twitter_id
  field :followers_ids,  :type => Array
  field :followings_ids, :type => Array
  @@twitter_fields.each { |f| field :"twitter_#{f}" }
  
  def raw=(twitter_response)
    twitter_fields.each { |tf| send("twitter_#{tf}=", twitter_response.send(tf)) if twitter_response.include?(tf) }
    self.twitter_status_created_at = twitter_response.try(:status).try(:created_at).try(:to_time)
  end
  
  def friends_ids
    followers_ids & followings_ids
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
