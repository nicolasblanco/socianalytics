namespace :twitter do
  namespace :users do
    task :update => :environment do
      User.all.each do |user|
        Resque.enqueue(TwitterUserJob, user.id, user.twitter_main_id)
      end
    end
    
    task :update_with_associated => :environment do
      User.all.each do |user|
        if main_twitter_user = user.twitter_user
          main_twitter_user.update_associated_with!(user)
        else
          Resque.enqueue(TwitterUserJob, user.id, user.twitter_main_id)
        end
      end
    end
  end
end
