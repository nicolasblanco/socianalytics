class TwitterStat
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :content, :type => Array, default: []
  field :stat_type
  index :stat_type

  referenced_in :twitter_user, index: true

  scope :for_stat_type, ->(stat_type) { where(:stat_type => stat_type) }
end
