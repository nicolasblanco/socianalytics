class Stats::Twitter::PopularFollower < Stats::Twitter::TwitterStat
  def execute
    self.content = twitter_client.followers.sort { |a, b| a.followers_count <=> b.followers_count }.reverse.first(15)
  end
end
