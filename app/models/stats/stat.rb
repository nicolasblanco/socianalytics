class Stats::Stat
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content, :type => Array
  
  referenced_in :user
end
