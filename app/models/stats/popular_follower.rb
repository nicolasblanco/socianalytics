class Stats::PopularFollower < Stats::Stat
  def execute
    self.content = user.twitter_client.followers.sort { |a, b| a.followers_count <=> b.followers_count }.reverse.first(15)
  end
end
