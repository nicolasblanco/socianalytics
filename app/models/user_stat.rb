class UserStat
  include Mongoid::Document
  include Mongoid::Timestamps

  field :followers, :type => Array
  field :number_of_followers, :type => Integer
  field :number_of_facebook_fans, :type => Integer

  referenced_in :user
end
