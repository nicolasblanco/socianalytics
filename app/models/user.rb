require 'digest/md5'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  #after_create :compute_new_user_data

  field :admin, :type => Boolean, :default => false, :accessible => false
  field :authorized, :type => Boolean, :default => false, :accessible => false
  field :twitter_handle
  field :twitter_oauth_token
  field :twitter_oauth_secret
  field :twitter_main_id
  field :last_mention_processed
  field :facebook_access_token
  field :facebook_page_id

  references_many :tweets
  references_many :user_stats
  references_many :campaigns
  references_many :short_urls
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  # :registerable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable, :registerable
         
  attr_accessible :email, :password, :password_confirmation, :remember_me, :facebook_page_id
  
  scope :linked_to_twitter, where(:twitter_main_id.exists => true)
  
  def self.find_by_twitter_handle(handle)
    first(:conditions => { :twitter_handle => handle })
  end
  
  def self.find_by_twitter_oauth_token_and_twitter_oauth_secret(token, secret)
    first(:conditions => { :twitter_oauth_token => token, :twitter_oauth_secret => secret })
  end
  
  def linked_to_twitter?
    twitter_oauth_token.present? && twitter_oauth_secret.present?
  end
  
  def twitter_client
    return unless twitter_oauth_token.present? && twitter_oauth_secret.present?
    
    @twitter_client ||= begin
      Twitter::Client.new({ :oauth_token => twitter_oauth_token, :oauth_token_secret => twitter_oauth_secret })
    end
  end
  
  def twitter_user
    TwitterUser.where(:twitter_id => twitter_main_id).first
  end
  
  def twitter_followers_count
    stats_twitter_follower_counts.last.try(:count)
  end
  
  def twitter_followers_delta_count
    return 0 if stats_twitter_follower_counts.empty?
    latest_index = stats_twitter_follower_counts.count - 1
    stats_twitter_follower_counts[latest_index].try(:count) - stats_twitter_follower_counts[latest_index - 1].try(:count)
  end
end
