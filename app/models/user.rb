require 'digest/md5'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :compute_new_user_data

  field :admin, :type => Boolean, :default => false, :accessible => false
  field :twitter_handle
  field :twitter_oauth_token
  field :twitter_oauth_secret
  field :last_mention_processed
  field :facebook_access_token
  field :facebook_page_id

  references_many :tweets
  references_many :user_stats
  references_many :campaigns

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :twitter_oauth
         
  attr_accessible :email, :password, :password_confirmation, :remember_me, :facebook_page_id
  
  def self.find_by_twitter_handle(handle)
    first(:conditions => { :twitter_handle => handle })
  end
  
  def self.find_by_twitter_oauth_token_and_twitter_oauth_secret(token, secret)
    first(:conditions => { :twitter_oauth_token => token, :twitter_oauth_secret => secret })
  end
  
  def twitter_client
    @twitter_client ||= begin
      Twitter::Base.new({ :access_key => twitter_oauth_token, :access_secret => twitter_oauth_secret })
    end
  end

  def self.compute_data
    User.all.each do |user|
      user.user_latest_tweets
      user.update_stats
      user.refresh_number_of_replies_count!
      user.tweets.retweeted.each do |tweet|
        tweet.update_stats
      end
    end
  end

  def user_latest_tweets
    self.twitter_client.user_timeline(:count => 200).each do |json|
      new_md5 = Digest::MD5.hexdigest(json.to_s)
      existing_tweet = Tweet.where("raw.id" => json.id).first
      if existing_tweet
        existing_tweet.update_attributes!(:raw => json, :md5 => new_md5) unless new_md5.eql?(existing_tweet.md5)
      else
        Tweet.create :raw => json, :user => self, :md5 => new_md5
      end
    end
  end

  def refresh_number_of_replies_count!
    if self.last_mention_processed != nil
      mentions = self.twitter_client.mentions(:since_id => self.last_mention_processed, :count=>200)
    else
      mentions = self.twitter_client.mentions(:count=>200)
    end

    tweetid_mentions_hash = {}
    mentions.each do |mention|
      if tweetid = mention.in_reply_to_status_id
        tweetid_mentions_hash[tweetid] = (tweetid_mentions_hash[tweetid] || 0) + 1
      end
    end

    #update tweets
    tweetid_mentions_hash.each do |tweetid, replies_count|

      tweet = Tweet.where("raw.id"=>tweetid).first
      if tweet
        #puts  tweetid, replies_count
        tweet.number_of_replies += replies_count
        tweet.save!
      end
    end

    #set self.last_mention_processed
    self.last_mention_processed = mentions.first.id if mentions.count > 0
    self.save!
  end

  def update_stats
    us = UserStat.new
    ids = twitter_client.follower_ids
    us.followers = ids
    us.number_of_followers = ids.size
    us.user = self
    if facebook_access_token.present? && facebook_page_id.present?
      facebook_hash = MiniFB.get(facebook_access_token, facebook_page_id)
      us.number_of_facebook_fans = facebook_hash[:fan_count]
    end
    
    us.save
  end

  protected
  def compute_new_user_data
    self.user_latest_tweets
    self.update_stats
    self.refresh_number_of_replies_count!
    self.tweets.retweeted.each do |tweet|
      tweet.update_stats
    end
  end
end
