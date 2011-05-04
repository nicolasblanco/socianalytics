class Statistic::Twitter::FollowingCount < Statistic::Twitter::Base
	def self.update_for(twitter_user)
		stat = find_for_twitter_user(twitter_user)
		stat.add_content(twitter_user.twitter_friends_count)
		stat.save
	end
end
