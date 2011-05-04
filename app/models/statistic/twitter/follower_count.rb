class Statistic::Twitter::FollowerCount < Statistic::Twitter::Base
	def self.update_for(twitter_user)
		stat = find_for_twitter_user(twitter_user)
		stat.add_content(twitter_user.twitter_followers_count)
		stat.save
	end
end
