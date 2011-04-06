class Stats::Twitter::TwitterStat < Stats::Stat
  def twitter_client
    user.twitter_client
  end
end
