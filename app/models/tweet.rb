class Tweet
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  before_validation :extract_bitly_urls
  
  field :number_of_replies, :type => Integer, :default => 0
  field :md5
  field :raw, :type => Hash

  references_many :tweet_stats
  referenced_in :user
  embeds_many :bitly_urls

  named_scope :retweeted, :where => { "raw.retweet_count" => { "$gt" => 0 } }

  def update_stats
    flw = user.twitter_client.retweeters_of(self.raw["id"])
    new_rts = self.tweet_stats.any? ? (flw.map(&:id) - self.tweet_stats.last.subfollowers_impacted) : flw.map(&:id)

    if new_rts.any?
      tw = TweetStat.new
      ids = new_rts 
      tw.subfollowers_impacted = ids
      tw.number_of_subfollowers = flw.map(&:followers_count).inject(&:+)
      tw.tweet = self
      tw.save
    end
  end

  def score
    (((self.number_of_replies.to_f + self.raw["retweet_count"].to_i) / [raw["user"]["followers_count"].to_i,1].max) * 10000).round
  end
  
  def raw=(value)
    value["created_at"] = Time.parse value["created_at"] if value["created_at"].is_a?(String)
    write_attribute(:raw, value)
  end
  
  def raw
    Hashie::Mash.new(read_attribute(:raw))
  end
  
  def extract_bitly_urls!
    extract_bitly_urls(true)
  end

protected
  
  def extract_bitly_urls(force = false)
    if new_record? || raw_changed? || force
      bitly_urls.clear
      raw["text"].scan(/bit\.ly\/(\w+)\s/).flatten.each do |url_chunk|
        bitly = Bitly.new(BitlyConfig.username, BitlyConfig.api_key)
        Rails.logger.debug("bitly check for #{url_chunk}")
        clicks = bitly.clicks(url_chunk)
        unless clicks.is_a?(Bitly::V3::MissingUrl)
          number_of_clicks = bitly.clicks(url_chunk).user_clicks 
          bitly_urls << BitlyUrl.new(:url_chunk => url_chunk, :number_of_clicks => bitly.clicks("http://bit.ly/#{url_chunk}").user_clicks)
        end
      end
    end
  end
end
