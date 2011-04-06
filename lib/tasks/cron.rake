namespace :cron do
  task :daily => :environment do
    User.all.each do |user|
      %w(stats_twitter_popular_followers stats_twitter_follower_counts).each do |stat_name|
        stat = user.send(stat_name).build
        stat.execute
        stat.save
      end
    end
  end
end
