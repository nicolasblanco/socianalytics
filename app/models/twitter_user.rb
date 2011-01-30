class TwitterUser
  include Mongoid::Document
  include Mongoid::Versioning
  include Mongoid::Timestamps
  
  @@twitter_fields = %w(location profile_image_url screen_name friends_count followers_count)
  cattr_reader :twitter_fields
  
  field :twitter_id
  field :followers_ids,  :type => Array
  field :followings_ids, :type => Array
  @@twitter_fields.each { |f| field :"twitter_#{f}" }
  
  def raw=(twitter_response)
    twitter_fields.each { |tf| send("twitter_#{tf}=", twitter_response.send(tf)) if twitter_response.include?(tf) }
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
  
  def update_associated_with!(user, force = false)
    puts "update_associated_with! for #{twitter_id}, force = #{force}"
    (followers_ids | followings_ids).each do |current_twitter_id|
      current_twitter_user = TwitterUser.where(:twitter_id => current_twitter_id).first
      Resque.enqueue(TwitterUserJob, user.id, current_twitter_id, false) if force || current_twitter_user.blank? || current_twitter_user.updated_at < 1.day.ago
    end
  end
  
  def stat_mash(attribute)
    Hashie::Mash.new(:updated_at => updated_at, :value => send(attribute))
  end
  
  def stat_for(attribute)
    versions.map { |v| v.stat_mash(attribute) }.push(stat_mash(attribute))
  end
end
