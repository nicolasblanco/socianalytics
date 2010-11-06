class Stats::Twitter::FollowerCount < Stats::Twitter::TwitterStat
  def execute
    self.content = [twitter_client.verify_credentials.followers_count]
  end
end
