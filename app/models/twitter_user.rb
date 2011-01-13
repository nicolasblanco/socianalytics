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
  
  def update_associated_with!(user, recursive = true)
    puts "update_associated_with! for #{twitter_id}, recursive = #{recursive}"
    (followers_ids | followings_ids).each do |twitter_id|
      current_twitter_user = TwitterUser.where(:twitter_id => twitter_id).first
      if current_twitter_user
        current_twitter_user.update_associated_with!(user, false) if recursive
      else
        Resque.enqueue(TwitterUserJob, user.id, twitter_id)
      end
    end
  end
end
