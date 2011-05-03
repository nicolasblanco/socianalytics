class Statistic::Twitter::FriendCount < Statistic::Twitter::Base
	def self.update_for(twitter_user)
		stat = find_for_twitter_user(twitter_user)
		stat.add_content(twitter_user.friends_size)
		stat.save
	end
end
