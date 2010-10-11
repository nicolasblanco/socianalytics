class TweetStat
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subfollowers_impacted, :type => Array
  field :number_of_subfollowers, :type => Integer

  referenced_in :tweet
end
