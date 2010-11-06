class Stats::Stat
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  
  field :content, :type => Array
  
  referenced_in :user
end
