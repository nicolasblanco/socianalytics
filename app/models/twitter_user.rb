class TwitterUser
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  
  field :raw, :type => Hash
  field :twitter_id
  field :followers_ids,  :type => Array
  field :followings_ids, :type => Array
  
  def friends_ids
    followers_ids & followings_ids
  end
  
  def async_update!(user)
    Resque.enqueue(TwitterUserJob, user.id, twitter_id)
  end
  
  def update_associated_with!(user, force = false)
    puts "update_associated_with! for #{twitter_id}, recursive = #{recursive}"
    (followers_ids | followings_ids).each do |current_twitter_id|
      current_twitter_user = TwitterUser.where(:twitter_id => current_twitter_id).first
      Resque.enqueue(TwitterUserJob, user.id, current_twitter_id) if force || current_twitter_user.blank? || current_twitter_user.updated_at < 3.days.ago
    end
  end
end
