namespace :twitter do
  namespace :users do
    task :update => :environment do
      User.all.each do |user|
        main_twitter_user = TwitterUser.where(:twitter_id => user.twitter_main_id).first
        if main_twitter_user
          main_twitter_user.update_associated_with!(user)
        else
          Resque.enqueue(TwitterUserJob, user.id, user.twitter_main_id)
        end
      end
    end
  end
end
