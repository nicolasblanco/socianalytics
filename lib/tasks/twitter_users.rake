namespace :twitter do
  namespace :users do
    task :update => :environment do
      User.all.each do |user|
        Resque.enqueue(TwitterUserJob, user.id, user.twitter_main_id, true)
      end
    end
    
    task :update_with_associated => :environment do
      User.all.each do |user|
        if main_twitter_user = user.twitter_user
          %w(followers_ids followings_ids).each do |method|
            main_twitter_user.send(method).each_slice(100) do |twitter_ids|
              Resque.enqueue(TwitterUserLookup, user.id, twitter_ids)
            end
          end
        else
          Resque.enqueue(TwitterUserJob, user.id, user.twitter_main_id, true)
        end
      end
    end
  end
end
