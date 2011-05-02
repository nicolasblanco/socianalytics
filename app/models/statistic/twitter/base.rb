class Statistic::Twitter::Base < Statistic::Base
	referenced_in :twitter_user, index: true

	def self.find_for_twitter_user(twitter_user)
		find_or_initialize_by(:twitter_user_id => twitter_user.id)
	end

	def self.stat_for_twitter_user(twitter_user)
		where(:twitter_user_id => twitter_user.id).first
	end

	def self.for_twitter_user(twitter_user, filter = :latest_24)
		return unless stat = stat_for_twitter_user(twitter_user)
		stat.content.select do |stat|
			case filter
			when :latest_week  then stat["at"] > 1.week.ago
			when :latest_month then stat["at"] > 1.month.ago
			else
				stat["at"] > 1.day.ago
			end
		end
	end
end
